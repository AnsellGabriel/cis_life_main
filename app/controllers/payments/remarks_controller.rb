class Payments::RemarksController < ApplicationController
  before_action :initialize_payment, only: %i[index new create show]

  def index
    @remarks = @payment.remarks.order(created_at: :desc)
  end

  def show
    @remark = @payment.remarks.find(params[:id])
  end

  def new
    @remark = @payment.remarks.build
  end

  def create
    @remark = @payment.remarks.build(remark_params.merge(user: current_user))

    if @remark.save
      if !@payment.rejected?
        # scope this in a transaction block
        @payment.transaction do
          @payment.reject
          @payment.entries.map(&:cancelled!)
          @payment.general_ledgers.update_all(transaction_date: nil)
        end

        redirect_to payment_remarks_path(@payment), alert: "Payment rejected."
      else
        redirect_to payment_remarks_path(@payment), alert: "Remark added."
      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def remark_params
    params.require(:remark).permit(:remark)
  end

  def initialize_payment
    @payment = Payment.find(params[:payment_id])
  end

end
