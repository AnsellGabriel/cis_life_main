class ReinsurancesController < ApplicationController
  before_action :set_reinsurance, only: %i[ show edit update destroy ]

  # GET /reinsurances
  def index
    @reinsurances = Reinsurance.all
  end

  # GET /reinsurances/1
  def show
  end

  # GET /reinsurances/new
  def new
    @reinsurance = Reinsurance.new
  end

  # GET /reinsurances/1/edit
  def edit
  end

  # POST /reinsurances
  def create
    # raise 'errors'

    @reinsurance = Reinsurance.new(reinsurance_params)

    # @batches = LoanInsurance::Batch.get_ri_batches(@reinsurance.date_from..@reinsurance.date_to)
    @members = Member.get_ri(@reinsurance.date_from, @reinsurance.date_to)

    if @members.empty?
      redirect_to reinsurances_path, alert: "No for reinsurance for that period."
    else
      if @reinsurance.save
        @reinsurance.add_members(@members, @retention_limit)
        # @reinsurance.set_total_prem_and_amount
        # @reinsurance.set_batches_ri_date
        redirect_to @reinsurance, notice: "Reinsurance was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
    # raise 'errors'
    # @members.each do |member|
    #   member.get_for_ri_sum(@reinsurance)
    # end

    # if @reinsurance.batches.empty?
    #   redirect_to reinsurances_path, alert: "No for reinsurance for that period."
    # else

    #   if @reinsurance.save
    #     @reinsurance.set_total_prem_and_amount
    #     # @reinsurance.set_batches_ri_date
    #     redirect_to @reinsurance, notice: "Reinsurance was successfully created."
    #   else
    #     render :new, status: :unprocessable_entity
    #   end

    # end

  end

  # PATCH/PUT /reinsurances/1
  def update
    if @reinsurance.update(reinsurance_params)
      redirect_to @reinsurance, notice: "Reinsurance was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /reinsurances/1
  def destroy
    @reinsurance.destroy
    redirect_to reinsurances_url, notice: "Reinsurance was successfully destroyed.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_reinsurance
    @reinsurance = Reinsurance.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reinsurance_params
    params.require(:reinsurance).permit(:date_from, :date_to)
  end
end
