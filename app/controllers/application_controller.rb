class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :set_cooperative

  def root
    case current_user.userable_type
    when "Agent"
      redirect_to agents_path
    when "CoopUser"
      redirect_to coop_members_path	
    when "Employee"
      case current_user.userable.department_id
      when 17
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
