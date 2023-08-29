class LoanInsurance::GroupRemitsController < ApplicationController
  before_action :set_agreement, only: %i[index new create show]
  before_action :set_group_remit, only: %i[show destroy]

  def index
    @group_remits = @agreement.group_remits.loan_remits
  end

  def show
    @batches = @group_remit.lppi_batches.order(created_at: :desc)
    @pagy, @batches = pagy(@batches, items: 10)
    @gr_presenter = GroupRemitPresenter.new(@group_remit)
  end

  def new 
    @group_remit = @agreement.group_remits.new(type: 'LoanInsurance::GroupRemit')
  end

  def create
    @group_remit = @agreement.group_remits.new(type: 'LoanInsurance::GroupRemit')
    @group_remit.name = params[:loan_insurance_group_remit][:name]

    begin
      if @group_remit.save!
        redirect_to loan_insurance_group_remits_path, notice: "New batch created"
      else
        render :new
      end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to loan_insurance_group_remits_path, alert: e.message.gsub(/^Validation failed: /, '')
    end
  end

  def destroy
    if @group_remit.destroy!
      redirect_to loan_insurance_group_remits_path, alert: "Remittance deleted"
    end
  end

  private
    def set_agreement
      @agreement = @cooperative.agreements.lppi
    end

    def set_group_remit
      @group_remit = LoanInsurance::GroupRemit.find(params[:id])
    end
end
