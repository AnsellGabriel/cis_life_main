class ApplicationController < ActionController::Base
    protected
    def after_sign_in_path_for(resource)
      if !resource.approved?
        sign_out resource
        root_path
      else
        super
      end
    end
end
