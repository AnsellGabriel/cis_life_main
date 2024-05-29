class Mis::MembersController < ApplicationController
  def index
    if can? :read, Member
      @q = Member.ransack(params[:q])
      @members = @q.result.order(:last_name, :first_name)
      @pagy, @members = pagy(@members, items: 10)
    else
      head :forbidden
    end
  end

  def show
    if can? :read, Member
      @member = Member.find(params[:id])
      @memberships = @member.coop_members.includes(:agreements)
    else
      head :forbidden
    end
  end


end
