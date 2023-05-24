class ApplicationController < ActionController::Base
    def root
        case current_user.userable_type
        when "Agent"
          redirect_to agents_path
        when "CoopUser"
          redirect_to pages_home_path
        when "Employee"
          redirect_to employees_path
        else
          super
        end
      end
end
