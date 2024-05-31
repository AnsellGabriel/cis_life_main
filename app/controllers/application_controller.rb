class ApplicationController < ActionController::Base
  include Pagy::Backend

  add_flash_types :warning
  before_action :set_cooperative, :set_authority_level, :set_current_date, :set_retention_limit, :authenticate_user!

  def root
    case current_user.userable_type
    when "Agent" then redirect_to agents_path
    when "CoopUser" then redirect_to coop_dashboard_path
    when "Employee"

      if current_user.medical_director?
        redirect_to med_directors_home_path
      else
        case current_user.userable.department_id
        # when 26 then redirect_to treasury_dashboard_path
        when 26 then redirect_to payments_path
        # when 27 then redirect_to audit_dashboard_path
        when 27 then redirect_to audit_for_audits_path
        # when 11 then redirect_to accounting_dashboard_path
        when 11 then redirect_to accounting_dashboard_path
        when 17, 13 then redirect_to process_coverages_path
        when 15 then redirect_to mis_dashboard_path
        when 14 then redirect_to reinsurances_path
        when 19 then redirect_to claims_dashboard_claims_process_claims_path
        else redirect_to employees_path
          
        end
      end

    else
      super
    end
  end

  private

  def set_cooperative
    if current_user
      if current_user.userable_type == "CoopUser"
        session[:c_id] ||= current_user.userable.cooperative_id
        @cooperative ||= Cooperative.find_by(id: session[:c_id])
      elsif params[:c_id]
        session[:c_id] = params[:c_id]
        @cooperative = Cooperative.find_by(id: session[:c_id])
      else
        @cooperative = Cooperative.find_by(id: session[:c_id])
      end
    end
  end

  def set_authority_level
    user_levels = current_user.user_levels.where(active: 1) if current_user
    if current_user.nil? || user_levels.empty?
      session[:max_amount] = 0
      session[:claims_max_amount]
    else
      user_levels.each do |ul|
        
        if ul.authority_level.claim?
          session[:claims_max_amount] = ul.authority_level.maxAmount
          @claims_user_authority_level = ul.authority_level
        elsif ul.authority_level.reconsider?
          session[:reconsider_limit] = ul.authority_level.maxAmount
          @claims_user_reconsider = ul.authority_level
        elsif ul.authority_level.underwriting?
          session[:max_amount] = ul.authority_level.maxAmount
        end
      end
      # raise "error"
    end
  end

  def set_current_date
    @current_date = Time.now
  end

  def set_retention_limit
    @retention_limit = LoanInsurance::Retention.find_by(active: true).amount
  end

  def check_agent
    unless current_user.userable_type == "Agent" || current_user.userable_type == "Employee"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def check_emp_department
    unless (current_user.userable_type == "Employee" && current_user.userable.department_id == 17) || current_user.senior_officer? # check if underwriting
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def check_actuarial_reinsurance
    unless (current_user.userable_type == "Employee" && current_user.userable.department_id == 14) || current_user.senior_officer? # check if underwriting
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def check_employee
    unless current_user.userable_type == "Employee"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  # def set_retention_limit
  #   @retention_limit = Retention.find_by(active: true)
  # end

  protected
  # Overwriting the sign_out redirect path method for unapproved users
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && !resource.approved?
      sign_out resource
      root_path
    else
      super
    end
  end

end
