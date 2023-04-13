class ApplicationController < ActionController::Base
  include Pagy::Backend

  def root
    case current_user.userable_type
    when "Agent"
      redirect_to agents_path
    when "CoopUser"
      redirect_to coop_members_path	
    when "Employee"
      redirect_to employees_path
    else
      super
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
