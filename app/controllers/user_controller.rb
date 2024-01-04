class UserController < ApplicationController

    def index 
        @users = User.where(approved: 0)
    end

    def approved
        @user = User.find(params[:id])
        if @user.approved 
            @approve = 0
        else
            @approve = 1
        end
          
        #   @user.approved = @approve
        #   @registration.attend_date = DateTime.now
      
          respond_to do |format|
            if @user.update_attribute(:approved, @approve)
              format.html { redirect_back fallback_location: user_index_path }
            end
        end
    end
end
