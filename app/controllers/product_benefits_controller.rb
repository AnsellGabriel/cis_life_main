class ProductBenefitsController < InheritedResources::Base
  before_action :set_product_benefit, only: %i[ show edit update destroy ]

  def show 
  end

  def new 
    # @product_benefit = ProductBenefit.new
    @agreement_benefit = AgreementBenefit.find(params[:v])
    @product_benefit = @agreement_benefit.product_benefits.build
  end

  def create
    # @product_benefit = ProcessRoute.new(product_benefit_params)
    @agreement_benefit = AgreementBenefit.find(params[:v])
    @agreement = @agreement_benefit.agreement
    @product_benefit = @agreement_benefit.product_benefits.build(product_benefit_params)
    respond_to do |format|
      if @product_benefit.save
        format.html { redirect_back fallback_location: @agreement, notice: "Benefit was successfully added." }
        format.json { render :show, status: :created, location: @product_benefit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit 
  end

  def update 
    respond_to do |format|
      if @product_benefit.update(product_benefit_params)
        format.html { redirect_back fallback_location: @agreement, notice: "Benefit was successfully updated." }
        # format.json { render :show, status: :ok, location: @agreement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_benefit.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy 
    @product_benefit.destroy
    @agreement = @agreement_benefit.agreement
    respond_to do |format|
      format.html { redirect_to @agreement, notice: "Anniversary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_product_benefit
      @product_benefit = ProductBenefit.find(params[:id])
      @agreement_benefit = AgreementBenefit.find(@product_benefit.agreement_benefit.id)
    end
    def product_benefit_params
      params.require(:product_benefit).permit(:coverage_amount, :premium, :agreement_benefit_id, :benefit_id, :duration, :residency_floor, :residency_ceiling)
    end
  # private

  #   def product_benefit_params
  #     params.require(:product_benefit).permit(:coverage_amount, :premium, :agreement_benefit_id, :benefit_id, :duration, :residency_floor, :residency_ceiling)
  #   end

end
