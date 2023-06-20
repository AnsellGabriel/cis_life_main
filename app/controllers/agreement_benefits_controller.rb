class AgreementBenefitsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_userable_type
  before_action :set_agreement_benefit, only: %i[ show edit update destroy ]

  # GET /agreement_benefits
  def index
    @agreement_benefits = AgreementBenefit.all
  end

  # GET /agreement_benefits/1
  def show
  end

  # GET /agreement_benefits/new
  def new
    @agreement_benefit = AgreementBenefit.new
  end

  # GET /agreement_benefits/1/edit
  def edit
  end

  # POST /agreement_benefits
  def create
    @agreement_benefit = AgreementBenefit.new(agreement_benefit_params)

    if @agreement_benefit.save
      redirect_to @agreement_benefit, notice: "Agreement benefit was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agreement_benefits/1
  def update
    if @agreement_benefit.update(agreement_benefit_params)
      redirect_to @agreement_benefit, notice: "Agreement benefit was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /agreement_benefits/1
  def destroy
    @agreement_benefit.destroy
    redirect_to agreement_benefits_url, notice: "Agreement benefit was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agreement_benefit
      @agreement_benefit = AgreementBenefit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agreement_benefit_params
      params.require(:agreement_benefit).permit(:agreements_id, :plans_id, :proposals_id, :options_id, :name, :description, :min_age, :max_age, :insured_type)
    end

    def check_userable_type
      unless current_user.userable_type == 'CoopUser'
        render file: "#{Rails.root}/public/404.html", status: :not_found
      end
    end
end
