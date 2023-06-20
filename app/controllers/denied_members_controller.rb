class DeniedMembersController < ApplicationController
	include CsvGenerator

	before_action :authenticate_user!
	before_action :set_group_remit

	def index
		@denied_members = @group_remit.denied_members.order(:name)
	end

	def download_csv
		@denied_members = @group_remit.denied_members.order(:name)

		generate_csv(@denied_members, "#{@group_remit.agreement.moa_no}-denied_members")
	end

	private

	def set_group_remit
		@group_remit = GroupRemit.find(params[:group_remit_id])
	end
end
  