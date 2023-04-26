class MembersController < InheritedResources::Base
  before_action :set_cooperative, only: %i[import new create edit update]

  def import
    file = params[:file]
    redirect_to coop_members_path, alert: "Only CSV file format please" unless file.content_type == "text/csv"

    # ! Attributes with Date type should have a format of: yyyy-mm-dd
    file = File.open(file)
    csv = CSV.parse(file, headers: true)
    
    created_members_counter = 0
    updated_members_counter = 0

    csv.each do |row|
      member_hash = {
        last_name: row["Last Name"].upcase,
        first_name: row["First Name"].upcase,
        middle_name: row["Middle Name"].upcase,
        suffix: row["Suffix"].upcase,
        birth_place: row["Birth Place"],
        birth_date: row["Birthdate"],
        gender: row["Gender"],
        address: row["Address"],
        sss_no: row["SSS #"],
        tin_no: row["TIN #"],
        mobile_number: row["Mobile #"],
        email: row["Email"],
        civil_status: row["Civil Status"],
        height: row["Height (cm)"],
        weight: row["Weight (kg)"],
        occupation: row["Occupation"],
        employer: row["Employer"],
        work_address: row["Work Address"],
        legal_spouse: row["Spouse"],
        work_phone_number: row["Work Phone #"]
      }

      coop_member_hash = {
        cooperative_id: @cooperative.id,
        coop_branch_id: CoopBranch.find_by(name: row["Branch"]).id,
        membership_date: row["Membership Date"],
        transferred: row["Transferred?"].downcase == "yes"
      } 

      # Check if a member with the same first name, last name, and birth date already exists
      existing_member = Member.find_by(
        first_name: member_hash[:first_name],
        last_name: member_hash[:last_name],
        birth_date: member_hash[:birth_date]
      )
      
      if existing_member
        # If a member already exists, update the record with the new data
        existing_member.update(member_hash)
        existing_member.coop_members.find_by(cooperative_id: @cooperative.id).update(coop_member_hash)

        updated_members_counter += 1
      else
        # If a member does not exist, create a new record
        new_member = Member.create(member_hash)
        new_member.coop_members.create(coop_member_hash)

        created_members_counter += 1
      end
    end

    redirect_to coop_members_path, notice: "#{created_members_counter} member(s) enrolled, #{updated_members_counter} member(s) updated."
  end

  def new
    @member = Member.new(
      birth_place: FFaker::Address.city,
      address: FFaker::Address.street_address,
      sss_no: FFaker::Identification.ssn,
      tin_no: FFaker::Identification.ssn,
      civil_status: 'Single',
      legal_spouse: FFaker::Name.name,
      height: '178',
      weight: '70',
      occupation: 'Programmer',
      employer: 'Company',
      work_address: FFaker::Address.street_address,
      work_phone_number: '09123456789',
      last_name: FFaker::Name.last_name,
      first_name: FFaker::Name.first_name,
      middle_name: FFaker::Name.last_name,
      suffix: 'Jr',
      email: FFaker::Internet.email,
      mobile_number: '09123456789',
      birth_date: FFaker::Time.date
    )
    @coop_member = @member.coop_members.build
  end

  def create
    @member = Member.new(member_params)
    respond_to do |format|  
      if @member.save
        format.html { 
          coop_member = @member.coop_members.last
          redirect_to coop_member_path(coop_member),
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

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

end
