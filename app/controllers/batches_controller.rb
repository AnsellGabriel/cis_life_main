class BatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cooperative, only: %i[index new create edit update show import]
  before_action :set_batch, only: %i[show edit update destroy]
  before_action :set_group_remit, only: %i[index new create edit update show import]

  def import
    # Check if a file has been uploaded
    file = params[:file]
    if file.nil?
      return redirect_to group_remit_path(@group_remit), alert: "No file uploaded"
    else
      return redirect_to group_remit_path(@group_remit), alert: "Only CSV file format please" unless file.content_type.end_with?("csv")
    end

    # Check if the file has the required headers
    required_headers = ["Active", "First Name", "Middle Name", "Last Name", "Suffix", "Status"]
    headers = CSV.open(file.path, &:readline).map(&:strip)
    missing_headers = required_headers - headers
    if missing_headers.any?
      return redirect_to group_remit_path(@group_remit), alert: "The following CSV headers are missing: #{missing_headers.join(', ')}"
    end
  
    # Read CSV file and parse its contents
    file = File.open(file)
    csv = CSV.parse(file, headers: true, skip_blanks: true).delete_if { |row| row.to_hash.values.all?(&:blank?) }

    if csv.count < 100
      return redirect_to group_remit_path(@group_remit), alert: "Imported members must be at least 100 for GYRT plan. Current count: #{csv.count}"
    end
  
    # Initialize variables to keep track of member imports
    added_members_counter = 0
    denied_members_counter = 0
    duplicate_members_counter = 0
    unenrolled_members_counter = 0
    @unenrolled_members_array = []
    @denied_members_array = []
    @duplicate_members_array = []
  
    # Iterate over each row in the CSV file
    csv.each do |row|  
      # Extract member data from CSV row
      batch_hash = {
        active: row["Active"],
        first_name: row["First Name"].upcase,
        middle_name: row["Middle Name"].upcase,
        last_name: row["Last Name"].upcase,
        suffix: row["Suffix"].upcase,
        status: row["Status"].downcase
      }
  
      # Find member in the database using their name
      member = Member.find_or_initialize_by(
        first_name: batch_hash[:first_name],
        last_name: batch_hash[:last_name],
        middle_name: batch_hash[:middle_name]
      )

      birth_date = member.birth_date
      member_age = Date.today.year - birth_date.year - ((Date.today.month > birth_date.month || (Date.today.month == birth_date.month && Date.today.day >= birth_date.day)) ? 0 : 1)

      if member_age < 18 or member_age > 65
        @denied_members_array << row
        denied_members_counter += 1
        next
      end

      unless member.persisted?
        @unenrolled_members_array << member
        unenrolled_members_counter += 1
        next
      end
  
      # Get the ID of the member's cooperative membership
      coop_member_id = member.coop_members.find_by(cooperative_id: @cooperative.id).id
  
      # Check if the member has already been added to this remittance batch
      duplicate_member = @group_remit.batches.find_by(coop_member_id: coop_member_id)
  
      if duplicate_member
        # Member has already been added to this remittance batch
        @duplicate_members_array << batch_hash
        duplicate_members_counter += 1
      elsif !duplicate_member
        # Member has not yet been added to this remittance batch
        new_batch = @group_remit.batches.build
  
        # Set batch attributes
        premium = @group_remit.agreement.premium
        coop_sf = @group_remit.agreement.coop_service_fee
        agent_sf = @group_remit.agreement.agent_service_fee
        terms = new_batch.group_remit.terms

        new_batch.active = batch_hash[:active]
        new_batch.status = batch_hash[:status] == "new" ? "recent" : batch_hash[:status]
        new_batch.coop_member_id = coop_member_id
        new_batch.premium = ((premium / 12) * terms)
        new_batch.coop_sf_amount = (coop_sf / 100) * new_batch.premium
        new_batch.agent_sf_amount = (agent_sf / 100) * new_batch.premium

        agreement = @group_remit.agreement
        coop_member = new_batch.coop_member
        renewal_member = agreement.coop_members.find_by(id: coop_member.id)
        
        if renewal_member.present?
          new_batch.status = :renewal
        else
          new_batch.status = :recent
          agreement.coop_members << coop_member
        end

        if row["Beneficiary"].present?
          # assuming the string is stored in a variable named 'relationship_string'
          dependents = row["Beneficiary"].split(",") # split the string by comma
          formatted_dependents = dependents.map do |dependent|
            name, relation = dependent.split(" - ").map(&:strip) # split each relationship by " - "
            first_name, last_name = name.split(" ").map(&:strip)
            
            member_dependent = MemberDependent.find_by(first_name: first_name, last_name: last_name)

            if member_dependent.persisted?
              batch_dependent = new_batch.batch_dependents.build
              batch_dependent.member_dependent_id = member_dependent.id
              batch_dependent.beneficiary = true
              batch_dependent.save
            end

          end
        end

        if row["Dependents"].present?
          # assuming the string is stored in a variable named 'relationship_string'
          dependents = row["Dependents"].split(",") # split the string by comma
          formatted_dependents = dependents.map do |dependent|
            name, relation = dependent.split(" - ").map(&:strip) # split each relationship by " - "
            first_name, last_name = name.split(" ").map(&:strip)
            
            member_dependent = MemberDependent.find_by(first_name: first_name, last_name: last_name)

            if member_dependent.present?
              batch_dependent = new_batch.batch_dependents.build
              batch_dependent.member_dependent_id = member_dependent.id
              batch_dependent.dependent = true
              batch_dependent.premium = ((premium / 12) * terms)
              batch_dependent.save
            end

          end
        end
  
        added_members_counter += 1 if new_batch.save
      else
        # Member data is invalid or incomplete
        @denied_members_array << batch_hash
        denied_members_counter += 1
      end
    end
  
    # Redirect user to remittance page with import status message
    import_message = "#{added_members_counter} member(s) added, #{duplicate_members_counter} duplicate members, #{denied_members_counter} member(s) denied. #{unenrolled_members_counter} unenrolled members"
    redirect_to group_remit_path(@group_remit), notice: import_message
  end
  

  def index
    # get all batches of the cooperative
    @batches = @group_remit.batches

    @pagy, @batches = pagy(@batches, items: 10)
  end

  def show
    @batch_member = @batch.coop_member
    @effectivity_date = @batch.group_remit.effectivity_date
    @expiry_date = @batch.group_remit.expiry_date
    @beneficiaries = @batch.batch_beneficiaries
    @dependents = @batch.batch_dependents

  end

  def new
    @coop_members = @cooperative.coop_members.includes(:member).order('members.last_name')

    @batch = @group_remit.batches.new(effectivity_date: FFaker::Time.date, expiry_date: FFaker::Time.date, active: true, status: :recent)


    # @member_dependent = @member.member_dependents.build
    # @batch_dependent = @batch.batch_dependents.build
  end

  def create
    @coop_members = @cooperative.coop_members.includes(:member).order('members.last_name')
    @batch = @group_remit.batches.new(batch_params)

    agreement = @group_remit.agreement
    coop_member = @batch.coop_member
    member_details = coop_member.member
    birth_date = member_details.birth_date
    member_age = Date.today.year - birth_date.year - ((Date.today.month > birth_date.month || (Date.today.month == birth_date.month && Date.today.day >= birth_date.day)) ? 0 : 1)

    if member_age < 18 or member_age > 65
      return redirect_to new_group_remit_batch_path(@group_remit), alert: "Member age must be between 18 and 65 years old."
    end

    renewal_member = agreement.coop_members.find_by(id: coop_member.id)

    if renewal_member.present?
        @batch.status = :renewal
    else
      if batch_params[:transferred].to_i == 1 # temporary checker for transferred members
        @batch.status = :renewal
        
      else
        @batch.status = :recent
      end
      agreement.coop_members << coop_member
    end
    
    premium = @group_remit.agreement.premium
    coop_sf = @group_remit.agreement.coop_service_fee
    agent_sf = @group_remit.agreement.agent_service_fee
    terms = @batch.group_remit.terms
    
    @batch.premium = ((premium / 12) * terms) 
    @batch.coop_sf_amount = (coop_sf/100) * @batch.premium
    @batch.agent_sf_amount = (agent_sf/100) * @batch.premium

    respond_to do |format|
      if @batch.save!
        set_premiums
        # format.turbo_stream
        format.html { 
          redirect_to group_remit_path(@group_remit)
        }
        format.turbo_stream { flash.now[:notice] = "Member successfully added." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end

  end

  def edit
  @coop_members = @cooperative.coop_members.includes(:member).order('members.last_name')

  end

  def update

    respond_to do |format|
      if @batch.update(batch_params)
        format.html { 
          redirect_to group_remit_path(@group_remit), notice: "Batch updated"
        }
        # format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    
    respond_to do |format|
      if @batch.destroy
        set_premiums
        format.html {
          redirect_to group_remit_path(@group_remit), alert: 'Batch was successfully destroyed.'
        }
        # format.turbo_stream { flash.now[:alert] = "Member removed" }
      else
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), alert: 'Unable to destroy batch.'
        }
      end
    end  
  end

  private
    def batch_params
      params.require(:batch).permit(:active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, :transferred, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy])
    end

    def set_group_remit
      @cooperative = current_user.userable.cooperative
      @group_remit = @cooperative.group_remits.find_by(id: params[:group_remit_id])
    end

    def set_cooperative
      @cooperative = current_user.userable.cooperative
    end

    def set_batch
      set_cooperative
      @group_remit = @cooperative.group_remits.find_by(id: params[:group_remit_id])
      @batch = @group_remit.batches.find_by(id: params[:id])
    end

    def set_premiums
      @batches_container = @group_remit.batches.order(created_at: :desc)
      @batches_dependents= BatchDependent.joins(batch: :group_remit)
        .where(group_remits: {id: @group_remit.id})

      # premium and commission totals
      batch_dependent_premiums = @group_remit.batches.joins(:batch_dependents).sum('batch_dependents.premium')
      @gross_premium = @group_remit.batches.sum(:premium) + batch_dependent_premiums
      @total_coop_commission = @group_remit.batches.sum(:coop_sf_amount)
      @total_agent_commission = @group_remit.batches.sum(:agent_sf_amount)
      @net_premium = @gross_premium - @total_coop_commission

      @principal_count = @batches_container.count
      @dependent_count = @batches_dependents.count
      @single_premium = @batches_container[0].premium if @batches_container[0].present?
      @single_dependent_premium = @batches_dependents[0].premium if @batches_dependents[0].present?
    end
end
