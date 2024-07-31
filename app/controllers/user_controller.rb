class UserController < ApplicationController
	before_action :set_user, only: %i[ show edit update destroy ]
    def index 
			# @users = User.all
			@q = User.ransack(params[:q])
			# @q = User.ransack(userable_of_Employee_type_last_name_or_userable_of_Employee_type_first_name)
			# raise 'errors'
			@users = @q.result(distinct: true)
	
			# use pagy
			@pagy, @users = pagy(@users, items: 10)
		end 

    def admin_dashboard
			@for_approved_users = User.where(approved: false)

			@pagy_users, @filtered_users = pagy(@for_approved_users, items: 10, link_extra: 'data-turbo-frame="pagination"')
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

		def destroy
			# if @user.userable_type == "CoopUser"
			# 	@coop_user = Coop
			# end
			# @user.destroy
    	redirect_to user_url, notice: "User was successfully destroyed, Joke only.", status: :see_other
		end

		private

			def set_user 
				@user = User.find(params[:id])
			end
end
