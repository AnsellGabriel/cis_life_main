class AnniversariesController < InheritedResources::Base
  before_action :authenticate_user!
  # before_action :check_userable_type
  before_action :set_anniversary, only: %i[ show edit update destroy ]

  def index
    @anniversaries = Anniversary.all
  end

  def show

  end

  def new
    @agreement = Agreement.find(params[:v])
    @anniversary = @agreement.anniversaries.build
  end

  def create
    @agreement = Agreement.find(params[:v])
    @anniversary = @agreement.anniversaries.build(anniversary_params)
    respond_to do |format|
      if @anniversary.save
        # format.html { redirect_to cooperative_coop_branches_path, notice: "Coop branch was successfully created." }
        format.html { redirect_back fallback_location: @agreement, notice: "Anniversary was successfully added." }
        format.json { render :show, status: :created, location: @anniversary }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @anniversary.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @anniversary.update(anniversary_params)
        format.html { redirect_back fallback_location: @agreement, notice: "Anniversary was successfully updated." }
        format.json { render :show, status: :ok, location: @anniversary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @anniversary.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @anniversary.destroy
    respond_to do |format|
      format.html { redirect_to @agreement, notice: "Anniversary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # def anniversary_params
  #   params.require(:anniversary).permit(:name, :anniversary_date, :agreement_id)
  # end

  def set_anniversary
    @anniversary = Anniversary.find(params[:id])
    @agreement = @anniversary.agreement
  end

  def anniversary_params
    params.require(:anniversary).permit(:name, :anniversary_date, :agreement_id)
  end

  # def check_userable_type
  #   unless current_user.userable_type == 'CoopUser'
  #     render file: "#{Rails.root}/public/404.html", status: :not_found
  #   end
  # end
end
