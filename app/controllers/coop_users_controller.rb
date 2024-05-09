class CoopUsersController < ApplicationController
  before_action :set_coop_user, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ index show edit update destroy ]

  def home
  end

  # GET /coop_users or /coop_users.json
  def index
    # @coop_users = CoopUser.all
    @f_employees = CoopUser.all
    @pagy, @coop_users = pagy(@f_employees, items: 20)
  end

  # GET /coop_users/1 or /coop_users/1.json
  def show
  end

  # # GET /coop_users/new
  # def new
  #   @coop_user = CoopUser.new(
  #     last_name: FFaker::Name.last_name,
  #     first_name: FFaker::Name.first_name,
  #     middle_name: FFaker::Name.last_name,
  #     mobile_number: FFaker::PhoneNumber,
  #     designation: FFaker::String
  #   )

  #   # new instance of the "User" class associated with the "Coop_user" instance.
  #   @coop_user.build_user
  # end

  # GET /coop_users/1/edit
  def edit
  end

  # POST /coop_users or /coop_users.json
  def create
    @form = :coop
    @coop_user = CoopUser.new(coop_user_params)
    # @branches = @coop_user&.cooperative.nil? ? [] : @coop_user&.cooperative&.coop_branches.order(:name)

    # initialize other forms for bootstrap tabs
    # new agent
    @agent = Agent.new
    @agent.build_user
    # new employee
    @employee = Employee.new
    @employee.build_user

    respond_to do |format|
            
      if @coop_user.save
        format.html { redirect_to unauthenticated_root_path, notice: "Account was successfully created. Please contact the administrator to activate your account." }
      else
        # re-initialize the cooperative and branches
        @cooperatives = Cooperative.all.pluck(:name, :id)
        format.html { render 'devise/registrations/new', status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coop_users/1 or /coop_users/1.json
  def update
    respond_to do |format|
      if @coop_user.update(coop_user_params)
        format.html { redirect_to coop_user_url(@coop_user), notice: "Account was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coop_users/1 or /coop_users/1.json
  def destroy
    @coop_user.destroy

    respond_to do |format|
      format.html { redirect_to coop_users_url, notice: "Coop User was successfully destroyed." }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_coop_user
    @coop_user = CoopUser.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def coop_user_params
    params.require(:coop_user).permit(:last_name, :first_name, :middle_name, :birthdate, :mobile_number, :designation, :cooperative_id, :coop_branch_id,
      user_attributes: [:email, :password, :password_confirmation, :userable_type, :userable_id])
  end

  # def check_userable_type
  #   unless current_user.userable_type == "CoopUser"
  #     render file: "#{Rails.root}/public/404.html", status: :not_found
  #   end
  # end
end
