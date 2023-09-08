class CoopMembersController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_coop_member, only: %i[show edit update destroy selected member_agreements show_insurance]

  def index
    # initalize new member for coop member modal form
    @member = Member.new
    @member.coop_members.build
    coop_members = @cooperative.coop_members
    f_members = Member.coop_member_details(coop_members)
      .filter_by_name(params[:last_name_filter], params[:first_name_filter])
    @pagy, @filtered_members = pagy(f_members, items: 10)
  end

  def new
    @beneficiary = @coop_member.coop_member_beneficiaries.build
  end

  def create
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
    super
  end

  def update
    respond_to do |format|
      if @coop_member.update!(coop_member_params)
        format.html { redirect_to @coop_member, notice: "Coop member updated."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @member = @coop_member.member
    @age = @member.age
    super
  end

  def selected
    @target = params[:target]
    @member = @coop_member.member
    @member_dependents = MemberDependent.where(member_id: @member.id)
    
    respond_to do |format|
      format.turbo_stream
    end
  end

  def find_member
    # @member = Member.find_by(id: params[:id])
    @member = CoopMember.find_by(id: params[:id])
    @group_remit = GroupRemit.find_by(id: params[:group_remit_id])
    @previous_loans = @member.lppi_batches(current_user.userable.cooperative, @group_remit)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def member_agreements
    # byebug
    @agreements = @coop_member.agreements.includes(:plan)
  end

  def show_insurance 
    # binding.pry
    @for_modal = params[:pro_cov].present? ? true : false
    
    @batch_gyrt = Batch.where(coop_member: @coop_member)
    @batch_lppi = LoanInsurance::Batch.where(coop_member: @coop_member)
    @batch = @batch_lppi + @batch_gyrt
  end

  private

    def set_coop_member
      @coop_member = CoopMember.find(params[:id])
    end

    def coop_member_params
      params.require(:coop_member).permit(:cooperative_id, :coop_branch_id, :last_name, :first_name, :middle_name, :suffix, :birthdate, :mobile_number, :email, :birth_place, :address, :sss_no, :tin_no, :civil_status, :legal_spouse, :height, :weight, :occupation, :employer, :work_address, :work_phone_number)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser' || current_user.userable_type == 'Employee'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
