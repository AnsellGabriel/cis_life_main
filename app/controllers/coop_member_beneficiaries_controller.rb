class CoopMemberBeneficiariesController < InheritedResources::Base
  before_action :set_beneficiary_coop_member, only: [:show, :edit, :update, :destroy]

  def show
  end
  
  def new
    @coop_member = CoopMember.find(params[:coop_member_id])
    @beneficiary = @coop_member.coop_member_beneficiaries.build
  end

  def edit
  end

  def create
    @coop_member = CoopMember.find(params[:coop_member_id])
    @beneficiary = @coop_member.coop_member_beneficiaries.build(coop_member_beneficiary_params)
    respond_to do |format|
      if @beneficiary.save
        format.html { redirect_to @coop_member, notice: "Account created successfully. Please wait for the admin to approve your account."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @beneficiary.update(coop_member_beneficiary_params)
        format.html { redirect_to @coop_member, notice: "Beneficiary was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @beneficiary.destroy

    respond_to do |format|
      format.html { redirect_to @coop_member, notice: "Beneficiary was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_beneficiary_coop_member
      @coop_member = CoopMember.find(params[:coop_member_id])
      @beneficiary = @coop_member.coop_member_beneficiaries.find(params[:id])
    end

    def coop_member_beneficiary_params
      params.require(:coop_member_beneficiary).permit(:last_name, :first_name, :middle_name, :suffix, :birthdate, :coop_member_id, :relationship)
    end

end
