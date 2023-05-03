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
      return redirect_to group_remit_path(@group_remit), alert: "Only CSV file format please" unless file.content_type == "text/csv"
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
  
    # Initialize variables to keep track of member imports
    added_members_counter = 0
    denied_members_counter = 0
    duplicate_members_counter = 0
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
      member = Member.find_by(
        first_name: batch_hash[:first_name],
        last_name: batch_hash[:last_name],
        middle_name: batch_hash[:middle_name]
      )
  
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
  
        new_batch.active = batch_hash[:active]
        new_batch.status = batch_hash[:status] == "new" ? "recent" : batch_hash[:status]
        new_batch.coop_member_id = coop_member_id
        new_batch.coop_sf_amount = (coop_sf / 100) * premium
        new_batch.agent_sf_amount = (agent_sf / 100) * premium
        new_batch.premium = premium
  
        added_members_counter += 1
      else
        # Member data is invalid or incomplete
        @denied_members_array << batch_hash
        denied_members_counter += 1
      end
    end
  
    # Redirect user to remittance page with import status message
    import_message = "#{added_members_counter} member(s) added, #{duplicate_members_counter} duplicate members, #{denied_members_counter} member(s) denied."
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

    premium = @group_remit.agreement.premium
    coop_sf = @group_remit.agreement.coop_service_fee
    agent_sf = @group_remit.agreement.agent_service_fee

    @batch.coop_sf_amount = (coop_sf/100) * premium 
    @batch.agent_sf_amount = (agent_sf/100) * premium 
    @batch.premium = premium 

    respond_to do |format|
      if @batch.save!
        set_premiums
        # format.turbo_stream
        format.html { 
          redirect_to group_remit_path(@group_remit), notice: "Member successfully added."
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
          redirect_to group_remit_path(@group_remit), notice: 'Batch was successfully destroyed.'
        }
        format.turbo_stream { flash.now[:alert] = "Member removed" }
      else
        format.html {
          redirect_to group_remit_batch_path(@group_remit, @batch), alert: 'Unable to destroy batch.'
        }
      end
    end  
  end

  private
    def batch_params
      params.require(:batch).permit(:active, :coop_sf_amount, :agent_sf_amount, :status, :premium, :coop_member_id, batch_dependents_attributes: [:member_dependent_id, :beneficiary, :_destroy])
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
      # premium and commission totals
      @gross_premium = @group_remit.batches.sum(:premium)
      @total_coop_commission = @group_remit.batches.sum(:coop_sf_amount)
      @total_agent_commission = @group_remit.batches.sum(:agent_sf_amount)
      @net_premium = @gross_premium - @total_coop_commission
    end
end
