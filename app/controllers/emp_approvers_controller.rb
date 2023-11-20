class EmpApproversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emp_approver, only: %i[ show edit update destroy ]

  # GET /emp_approvers
  def index
    @emp_approvers = EmpApprover.all
  end

  # GET /emp_approvers/1
  def show
  end

  # GET /emp_approvers/new
  def new
    @emp_approver = EmpApprover.new
  end

  # GET /emp_approvers/1/edit
  def edit
  end

  # POST /emp_approvers
  def create
    @emp_approver = EmpApprover.new(emp_approver_params)

    if @emp_approver.save
      redirect_to @emp_approver, notice: "Emp approver was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emp_approvers/1
  def update
    if @emp_approver.update(emp_approver_params)
      redirect_to @emp_approver, notice: "Emp approver was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /emp_approvers/1
  def destroy
    @emp_approver.destroy
    redirect_to emp_approvers_url, notice: "Emp approver was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_emp_approver
    @emp_approver = EmpApprover.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def emp_approver_params
    params.require(:emp_approver).permit(:employee_id, :approver_id)
  end
end
