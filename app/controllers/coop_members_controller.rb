class CoopMembersController < InheritedResources::Base
  def index
    @cooperative = current_user.userable.cooperative
    super
  end

  def new
    @cooperative = current_user.userable.cooperative
    @coop_member = CoopMember.new(coop_branch_id: 1, last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, suffix: 'Jr', birthdate: Date.today, mobile_number: '09123456789', email: FFaker::Internet.email)
    # @beneficiary = @coop_member.coop_member_beneficiaries.build(last_name: FFaker::Name.last_name, first_name: FFaker::Name.first_name, middle_name: FFaker::Name.last_name, suffix: 'Jr', relationship: 'Brother')
    super
  end

  def create
    @coop_member = CoopMember.new(coop_member_params)

    respond_to do |format|
      if @coop_member.save
        format.html { redirect_to @coop_member, notice: "Account created successfully. Please wait for the admin to approve your account."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  def edit
    @cooperative = current_user.userable.cooperative
    super
  end
  
  def show
    @coop_member = CoopMember.find(params[:id])
    @beneficiaries = @coop_member.coop_member_beneficiaries
    super
  end

  private

    def coop_member_params
      params.require(:coop_member).permit(:cooperative_id, :coop_branch_id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :mobile_number, :email, :coop_member_beneficiaries_attributes => [:id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :relationship, :coop_member_id, :_destroy])
    end

end
