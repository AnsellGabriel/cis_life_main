class Payments::RemarksController < ApplicationController
  before_action :initialize_payment_and_remark, only: %i[new create show]

  def show
    @remark = @payment.remarks.find(params[:id])
  end

  def new
    @remark = @payment.remarks.build
  end

  def create
    @remark = @payment.remarks.build(remark_params.merge(user: current_user))

    if @remark.save
      @payment.reject

      redirect_to payments_path, alert: "Payment rejected."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def remark_params
    params.require(:remark).permit(:remark)
  end

  def initialize_payment_and_remark
    @payment = Payment.find(params[:payment_id])
  end

end
