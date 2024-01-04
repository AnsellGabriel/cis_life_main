class ApplicationController < ActionController::Base
  include Pagy::Backend

  add_flash_types :warning
  before_action :set_cooperative, :set_authority_level, :set_current_date

  def root
    case current_user.userable_type
    when "Agent" then redirect_to agents_path
    when "CoopUser" then redirect_to coop_dashboard_path
    when "Employee"

      if current_user.medical_director?
        redirect_to med_directors_home_path
      else
        case current_user.userable.department_id
        when 26 then redirect_to treasury_dashboard_path
        when 11 then redirect_to accounting_dashboard_path
        when 17, 13 then redirect_to process_coverages_path
        when 15 then redirect_to mis_dashboard_path
        else redirect_to employees_path
        end
      end

    else
      super
    end
  end

  private

  def set_cooperative
    if current_user && current_user.userable_type == "CoopUser"
      session[:c_id] ||= current_user.userable.cooperative_id
      @cooperative ||= Cooperative.find_by(id: session[:c_id])
    elsif params[:c_id]
      session[:c_id] = params[:c_id]
      @cooperative = Cooperative.find_by(id: session[:c_id])
    else
      @cooperative = Cooperative.find_by(id: session[:c_id])
    end

  end

  def set_authority_level
    if current_user.nil? || current_user.user_levels.count == 0
      session[:max_amount] = 0
    else
      @cur_user_max_amount = current_user.user_levels.find_by(active: true).authority_level.maxAmount
      # raise "error"
      session[:max_amount] = @cur_user_max_amount.nil? ? 0 : @cur_user_max_amount
    end
  end

  def set_current_date
    @current_date = Time.now
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
