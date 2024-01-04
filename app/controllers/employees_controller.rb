class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ index show edit update destroy ]

  # GET /employees or /employees.json
  def index
    @f_employees = Employee.includes(:department).all
    @pagy, @employees = pagy(@f_employees, items: 20)
  end

  # GET /employees/1 or /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new(last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, employee_number: FFaker::Number,
mobile_number: FFaker::PhoneNumber, designation: FFaker::String)

    # new instance of the "User" class associated with the "Employee" instance.
    @employee.build_user
    @employee = Employee.new(last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, mobile_number: FFaker::PhoneNumber.phone_calling_code, designation: FFaker::Job.job_noun)
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to unauthenticated_root_path, notice: "Account created successfully. Please wait for the admin to approve your account." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Employee was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Employee was successfully destroyed." }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    params.require(:employee).permit(:last_name, :first_name, :middle_name, :birthdate, :employee_number, :mobile_number, :designation, :department_id,
user_attributes: [:email, :password, :password_confirmation, :userable_type, :userable_id])
  end
end
