class EmpAgreementsController < ApplicationController
  before_action :set_emp_agreement, only: %i[ show edit update destroy ]

  # GET /emp_agreements
  def index
    @emp_agreements = EmpAgreement.all
  end

  def transfer_index
    @emp_agreements = EmpAgreement.all
  end
  

  # GET /emp_agreements/1
  def show
  end

  # GET /emp_agreements/new
  def new
    # raise 'errors'
    if params[:agreement].nil?
      @emp_agreement = EmpAgreement.new
    else
      @old_emp_agreement = EmpAgreement.find(params[:old_emp_agreement])
      @agreement = Agreement.find_by(id: params[:agreement])
      @emp_agreement = EmpAgreement.new(agreement: @agreement)
    end
  end

  # GET /emp_agreements/1/edit
  def edit
    # unless params[:agreement].nil?

    # end
  end

  # POST /emp_agreements
  def create
    # raise 'errors'
    @emp_agreement = EmpAgreement.new(emp_agreement_params)
    @old_emp_agreement = EmpAgreement.find_by(id: params[:emp_agreement][:old_emp_agreement])
    if @emp_agreement.save
      unless @old_emp_agreement.nil?
        @old_emp_agreement.update_attribute(:active, false)
        @emp_agreement.update_attribute(:category_type, "sub_approver")
      end
      redirect_to @emp_agreement, notice: "Emp agreement was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emp_agreements/1
  def update
    # raise 'errors'
    if @emp_agreement.update!(emp_agreement_params)
      redirect_to @emp_agreement, notice: "Emp agreement was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /emp_agreements/1
  def destroy
    @emp_agreement.destroy
    redirect_to emp_agreements_url, notice: "Emp agreement was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emp_agreement
      @emp_agreement = EmpAgreement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def emp_agreement_params
      params.require(:emp_agreement).permit(:employee_id, :agreement_id, :active, :category_type)
    end
end
