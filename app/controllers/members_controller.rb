class MembersController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type 

  def import
    import_service = CsvImportService.new(
      :member, 
      params[:file],  
      @cooperative,
      nil,
      current_user.userable
    )
    
    import_message = import_service.import

    if import_message.is_a?(String)
      redirect_to coop_members_path, alert: import_message
    else
      redirect_to coop_members_path, notice: "#{import_message[:created_members_counter]} members enrolled. #{import_message[:updated_members_counter]} members updated."
    end

    reset_session_progress
  end

  def new
    @member = Member.new(
      # birth_place: FFaker::Address.city,
      # address: FFaker::Address.street_address,
      # sss_no: FFaker::Identification.ssn,
      # tin_no: FFaker::Identification.ssn,
      # civil_status: 'Single',
      # legal_spouse: FFaker::Name.name,
      # height: '178',
      # weight: '70',
      # occupation: 'Programmer',
      # employer: 'Company',
      # work_address: FFaker::Address.street_address,
      # work_phone_number: '09123456789',
      # last_name: FFaker::Name.last_name,
      # first_name: FFaker::Name.first_name,
      # middle_name: FFaker::Name.last_name,
      # suffix: 'Jr',
      # email: FFaker::Internet.email,
      # mobile_number: '09123456789',
      # birth_date: FFaker::Time.date
    )
    @coop_member = @member.coop_members.build
  end

  def create
    @member = Member.new(member_params)
    respond_to do |format|  
      if @member.save
        format.html { 
          coop_member = @member.coop_members.find_by(cooperative_id: @cooperative.id)
          redirect_to coop_members_path,
          notice: "Member was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @member = Member.find(params[:id])
    @coop_member = @member.coop_members.find_by(cooperative_id: @cooperative.id)
  end

  def update
    @member = Member.find(params[:id])
    @coop_member = @member.coop_members.find_by(cooperative_id: @cooperative.id)

    respond_to do |format|
      if @member.update(member_params)
        format.html { 
          redirect_to coop_member_path(@coop_member),
          notice: "Member was successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
  
  private

    def member_params
      params.require(:member).permit(:birth_place, :address, :sss_no, :tin_no, :civil_status, :legal_spouse, :height, :weight, :occupation, :employer, :work_address, :work_phone_number, :last_name, :first_name, :middle_name, :suffix, :email, :mobile_number, :birth_date, :gender, coop_members_attributes: [:id, :cooperative_id, :coop_branch_id, :membership_date, :transferred, :_destroy])
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser' || current_user.userable_type == 'Employee'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end

    def reset_session_progress
      session[:member_import_progress] = {
        progress: 0
      }
    end
end
