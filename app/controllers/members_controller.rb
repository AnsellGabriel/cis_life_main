class MembersController < InheritedResources::Base
  before_action :set_cooperative, only: [:new, :create, :edit]

  def new
    @member = Member.new
    @member.coop_members.build
  end

  def create
    @member = Member.new(member_params)
    if @member.save!
      redirect_to @member, notice: "Member was successfully created."
    else
      format.html { render :new, status: :unprocessable_entity }
    end
  end
  
  private

    def member_params
      params.require(:member).permit(:birth_place, :address, :sss_no, :tin_no, :civil_status, :legal_spouse, :height, :weight, :occupation, :employer, :work_address, :work_phone_number, :last_name, :first_name, :middle_name, :suffix, :email, :mobile_number, :birth_date, :gender, coop_members_attributes: [:cooperative_id, :coop_branch_id, :membership_date, :transferred])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

end
