class ApplicationController < ActionController::Base
  add_flash_types :warning
  include Pagy::Backend

  before_action :set_cooperative, :set_authority_level

  def root
    case current_user.userable_type
    when "Agent"
      redirect_to agents_path
    when "CoopUser"
      redirect_to coop_members_path	
    when "Employee"
      case current_user.userable.department_id
      when 17, 13
        redirect_to process_coverages_path
      else
        redirect_to employees_path
      end
    else
      super
    end
  end

  private

  def set_cooperative
    if current_user && current_user.userable_type == 'CoopUser'
      session[:cooperative_id] ||= current_user.userable.cooperative_id
      @cooperative ||= Cooperative.find_by(id: session[:cooperative_id])
    end
  end

  def set_authority_level
    if current_user.nil? || current_user.user_levels.count == 0
      session[:max_amount] = 0
    else
      cur_user_max_amount = current_user.user_levels.find_by(active: true).authority_level.maxAmount
      session[:max_amount] = cur_user_max_amount.nil? ? 0 : cur_user_max_amount
    end
  end
  
  
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
