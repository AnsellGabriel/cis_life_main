class CoopMembersController < InheritedResources::Base
  before_action :authenticate_user!

  def index
    # get current cooperative
    @cooperative = current_user.userable.cooperative
    # get all coop members of the cooperative
    @coop_members = CoopMember.where(cooperative_id: @cooperative.id)
    # get all members data of the cooperative
    f_members = Member.joins(:coop_members).where(coop_members: { id: @coop_members.ids })
    # filter members based on last name
    @members = f_members.where("last_name LIKE ?", "%#{params[:filter]}%")
    # paginate members
    @pagy, @filtered_members = pagy(@members, items: 10)
    super
  end

  def new
    @cooperative = current_user.userable.cooperative
    # @coop_member = CoopMember.new(coop_branch_id: 1, last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, suffix: 'Jr', birthdate: Date.today, mobile_number: '09123456789', email: FFaker::Internet.email)
    # @beneficiary = @coop_member.coop_member_beneficiaries.build(last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, suffix: 'Jr', relationship: 'Brother')
    @beneficiary = @coop_member.coop_member_beneficiaries.build
    super
  end

  def create
    @cooperative = current_user.userable.cooperative
    @coop_member = CoopMember.new(coop_member_params)

    respond_to do |format|
      if @coop_member.save
        format.html { redirect_to @coop_member, notice: "Coop member enrolled."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @cooperative = current_user.userable.cooperative
    super
  end

  def update
    @cooperative = current_user.userable.cooperative
    @coop_member = CoopMember.find(params[:id])

    respond_to do |format|
      if @coop_member.update(coop_member_params)
        format.html { redirect_to @coop_member, notice: "Coop member updated."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @coop_member = CoopMember.find(params[:id])
    @member = @coop_member.member
    # @beneficiaries = @coop_member.coop_member_beneficiaries

    # compute coop_member age
    birth_date = @member.birth_date
    @age = Date.today.year - birth_date.year - ((Date.today.month > birth_date.month || (Date.today.month == birth_date.month && Date.today.day >= birth_date.day)) ? 0 : 1)
    super
  end

  private

    def coop_member_params
      params.require(:coop_member).permit(:cooperative_id, :coop_branch_id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :mobile_number, :email, :birth_place, :address, :sss_no, :tin_no, :civil_status, :legal_spouse, :height, :weight, :occupation, :employer, :work_address, :work_phone_number)
    end

end
