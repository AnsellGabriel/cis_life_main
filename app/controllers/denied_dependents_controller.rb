class DeniedDependentsController < ApplicationController
  include CsvGenerator

	before_action :set_group_remit
  before_action :set_denied_dependent, only: %i[ show edit update destroy ]

  # GET /denied_dependents
  def index
		@denied_dependents = @group_remit.denied_dependents.order(created_at: :desc)
  end

  def download_csv
		@denied_dependents = @group_remit.denied_dependents.order(:name)

		generate_csv(@denied_dependents, "#{@group_remit.agreement.moa_no}-denied_dependents")
	end

  # GET /denied_dependents/1
  def show
  end

  # GET /denied_dependents/new
  def new
    @denied_dependent = DeniedDependent.new
  end

  # GET /denied_dependents/1/edit
  def edit
  end

  # POST /denied_dependents
  def create
    @denied_dependent = DeniedDependent.new(denied_dependent_params)

    if @denied_dependent.save
      redirect_to @denied_dependent, notice: "Denied dependent was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /denied_dependents/1
  def update
    if @denied_dependent.update(denied_dependent_params)
      redirect_to @denied_dependent, notice: "Denied dependent was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /denied_dependents/1
  def destroy
    @denied_dependent.destroy
    redirect_to denied_dependents_url, notice: "Denied dependent was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_denied_dependent
      @denied_dependent = DeniedDependent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def denied_dependent_params
      params.require(:denied_dependent).permit(:name, :age, :reason, :group_remit_id)
    end

    def set_group_remit
      @group_remit = GroupRemit.find(params[:group_remit_id])
    end
end
