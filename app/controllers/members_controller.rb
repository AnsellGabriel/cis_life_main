
class MembersController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_member, only: %i[show edit update destroy show_coverages]

  def import
    import_service = CsvImportService.new(
      :member,
      params[:file],
      @cooperative,
      nil,
      current_user
    )

    import_message = import_service.import

    if current_user.userable_type == "CoopUser"
      import_redirect(coop_members_path, import_message)
    else
      import_redirect(@cooperative, import_message)
    end
  end

  def show_coverages
    @for_modal = params[:pro_cov].present? ? true : false
    @lppi_batches = LoanInsurance::Batch.get_member_lppi_coverages(@member)
    @gyrt_batches = Batch.get_member_gyrt_coverages(@member)

  end

  def new
    # byebug
    if params[:coop_id].present?
      @cooperative = Cooperative.find(params[:coop_id])
    end
    @member = Member.new()
    dummy_data
    @coop_member = @member.coop_members.build
    @prov = @muni = @brgy = []
  end

  def dummy_data
    if Rails.env.development?
      @member.birth_place = FFaker::Address.city
      @member.address = FFaker::Address.street_address
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
      @member.last_name = FFaker::Name.last_name
      @member.first_name = FFaker::Name.first_name
      @member.middle_name = FFaker::Name.last_name
      @member.birth_date = FFaker::Time.date
      # suffix: 'Jr',
      # email: FFaker::Internet.email,
      # mobile_number: '09123456789',
      # birth_date: FFaker::Time.date
    end
  end

  def create
    @member = Member.find_or_initialize_by(
      first_name: member_params[:first_name].squish,
      middle_name: member_params[:middle_name].squish,
      last_name: member_params[:last_name].squish,
      birth_date: member_params[:birth_date]
    )

    if @member.persisted?
      coop_member = @cooperative.coop_members.find_or_initialize_by(member_id: @member.id)
      coop_member.new_record? ? persisted = false : persisted = true
    end

    respond_to do |format|
      if persisted
        format.html {
          if current_user.userable_type == "CoopUser"
            redirect_to coop_members_path(cooperative_id: @cooperative.id),
            alert: "#{'Member already enrolled.'}"
          elsif current_user.userable_type == "Employee"
            redirect_to cooperative_path(@cooperative), alert: "#{'Member already enrolled.'}"
          end
        }
      else
        @member.assign_attributes(member_params)

        if @member.save

          format.html {
            if current_user.userable_type == "CoopUser"
              # coop_member = @member.coop_members.find_by(cooperative_id: @cooperative.id)
              redirect_to coop_members_path(cooperative_id: @cooperative.id),
              notice: "#{'Member enrolled.'}"
            elsif current_user.userable_type == "Employee"
              redirect_to cooperative_path(@cooperative), notice: "#{'Member enrolled.'}"
            end
          }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def edit
    @member = Member.find(params[:id])

    if params[:cooperative_id]
      @cooperative = Cooperative.find(params[:cooperative_id])
    end

    @prov = GeoProvince.where(geo_region_id: @member.geo_region_id)
    @muni = GeoMunicipality.where(geo_province_id: @member.geo_province_id)
    @brgy = GeoBarangay.where(geo_municipality_id: @member.geo_municipality_id)

    @coop_member = @member.coop_members.find_by(cooperative_id: @cooperative.id)
  end

  def update
    @member = Member.find(params[:id])
    @coop_member = @member.coop_members.find_by(cooperative_id: @cooperative.id)

    respond_to do |format|
      if @member.update(member_params)
        format.html {
          if current_user.userable_type == "CoopUser"
            redirect_to coop_members_path,
            notice: "Member was successfully updated."
          elsif current_user.userable_type == "Employee"
            redirect_to cooperative_path(@cooperative), notice: "Member was successfully updated."
          end
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end
  def member_params
    params.require(:member).permit(:birth_place, :address, :sss_no, :tin_no, :civil_status, :legal_spouse, :height, :weight, :occupation, :employer, :work_address, :work_phone_number, :last_name, :first_name, :middle_name, :suffix, :email, :mobile_number, :birth_date, :gender, :geo_region_id, :geo_province_id, :geo_municipality_id, :geo_barangay_id,
      coop_members_attributes: [:id, :cooperative_id, :coop_branch_id, :membership_date, :transferred, :_destroy])
  end

  def check_userable_type
    unless current_user.userable_type == "CoopUser" || current_user.userable_type == "Employee"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end

  def import_redirect(path, import_message)
    if import_message.is_a?(String)
      redirect_to path, alert: import_message
    else
      redirect_to path,
notice: "#{import_message[:created_members_counter] > 0 ? "#{import_message[:created_members_counter]} members enrolled. " : '' } #{import_message[:updated_members_counter] > 0 ? "#{import_message[:updated_members_counter]} members updated." : ''} #{import_message[:denied_enrollees_counter] > 0 ? "#{import_message[:denied_enrollees_counter]} members denied." : ''}"
    end
  end
end
