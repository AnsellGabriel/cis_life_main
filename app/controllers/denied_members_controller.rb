class DeniedMembersController < ApplicationController
	include CsvGenerator

	before_action :authenticate_user!
	before_action :set_group_remit

	def index
		@denied_members = @group_remit.denied_members.order(created_at: :desc)
	end

	def download_csv
		@denied_members = @group_remit.denied_members.order(:name)

		generate_csv(@denied_members, "#{@group_remit.agreement.moa_no}-denied_members")
	end

	def destroy_all
		@group_remit.denied_members.destroy_all

		redirect_to group_remit_path(@group_remit), notice: "Denied members deleted successfully."
	end

	private

	def set_group_remit
		@group_remit = GroupRemit.find(params[:group_remit_id])
	end
end
