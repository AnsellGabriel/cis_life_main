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
    raise 'errors'
    @reinsurance = Reinsurance.new(reinsurance_params)

    # @batches = LoanInsurance::Batch.get_ri_batches(@reinsurance.date_from..@reinsurance.date_to)
    ri_start = @reinsurance.date_from
    ri_end = @reinsurance.date_to
    @members = Member.get_ri

    @members.each do |member|
      member.coop_members.each do |cm|
        batch_total = cm.loan_batches.where("(effectivity_date <= ? and expiry_date >= ?) OR (effectivity_date <= ? and expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).sum(:loan_amount)
        if batch_total >= 350000
          cm.loan_batches.where("(effectivity_date <= ? and expiry_date >= ?) OR (effectivity_date <= ? and expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).each do |batch|
            @reinsurance.batches << batch
          end
        end
      end
    end

    # @batches.each do |batch|
    #   @reinsurance.batches << batch
    # end
    
    
    if @reinsurance.save
      @reinsurance.set_total_prem_and_amount
      redirect_to @reinsurance, notice: "Reinsurance was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
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
