class Mis::MembersController < ApplicationController
  def index
    @cooperatives = Cooperative.all
  end

  def update_table
    @cooperative = Cooperative.find(params[:cooperative])
    @coop_members = @cooperative.coop_members.includes(:member)
    @pagy, @coop_members = pagy(@coop_members, items: 10)

    respond_to do |format|
      format.turbo_stream
    end
  end


end
