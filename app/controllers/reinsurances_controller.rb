class ReinsurancesController < ApplicationController
  include CsvGenerator
  before_action :check_actuarial_reinsurance
  before_action :set_reinsurance, only: %i[ show edit update destroy ri_csv ]


  # GET /reinsurances
  def index
    @reinsurances = Reinsurance.all
  end

  # GET /reinsurances/1
  def show
    @ri_members = @reinsurance.get_members
    @pagy_ri_members, @filtered_ri_members = pagy(@ri_members, items: 5, page_param: :ri_mem, link_extra: 'data-turbo-frame="ri_mem_pagination"')
  end

  def ri_csv
    @ri_batches = @reinsurance.get_members

    # generate_csv(@ri_batches, "#{@reinsurance.date_from} to #{@reinsurance.date_to}-reinsurance")
    ri_generate_csv(@ri_batches, "#{@reinsurance.date_from} to #{@reinsurance.date_to}-reinsurance", @reinsurance.date_from, @reinsurance.date_to)
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

    if @reinsurance.check_ri_terms <= 0
      redirect_to reinsurances_path, alert: "Reinsurance Term must be greater than zero."
    else

      if @members.empty?
        redirect_to reinsurances_path, alert: "No for reinsurance for that period."
      else
        if @reinsurance.save
          @reinsurance.add_members(@members, @retention_limit)
          @reinsurance.set_total_prem_and_amount
          # @reinsurance.set_batches_ri_date
          redirect_to @reinsurance, notice: "Reinsurance was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end
    
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
