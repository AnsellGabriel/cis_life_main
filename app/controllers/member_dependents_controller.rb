class MemberDependentsController < InheritedResources::Base
  before_action :authenticate_user!
  # before_action :check_userable_type
  before_action :set_member
  before_action :set_member_dependent, only: [:show, :edit, :update, :destroy]

  def index
    @member_dependents = @member.member_dependents
  end

  def new
    @member_dependent = @member.member_dependents.build(
      # first_name: FFaker::Name.first_name,
      # middle_name: FFaker::Name.first_name,
      # last_name: FFaker::Name.last_name,
      # suffix: FFaker::Name.suffix,
      # birth_date: FFaker::Time.between(50.years.ago, 1.year.ago),
      # relationship: "Family"
    )
  end

  def new_beneficiary
    @member_dependent = @member.member_dependents.build(
      # first_name: FFaker::Name.first_name,
      # middle_name: FFaker::Name.first_name,
      # last_name: FFaker::Name.last_name,
      # suffix: FFaker::Name.suffix,
      # birth_date: FFaker::Time.between(50.years.ago, 1.year.ago),
      # relationship: "Family"
    )
    @claims = params[:claims]

  end

  def create_beneficiary
    @member_dependent = @member.member_dependents.find_or_initialize_by(
      first_name: member_dependent_params[:first_name],
      last_name: member_dependent_params[:last_name],
      birth_date: member_dependent_params[:birth_date]
    )

    respond_to do |format|
      if @member_dependent.persisted?
        format.html { redirect_to new_group_remit_batch_beneficiary_path(@group_remit, @batch, error: true), notice: "Dependent already exists" }
      else
        @member_dependent = @member.member_dependents.build(member_dependent_params)

        if @member_dependent.save
          if member_dependent_params[:claims]
            format.html { redirect_to new_group_remit_batch_beneficiary_path(@group_remit, @batch, claims: true), notice: "Member dependent was successfully created." }
          else
            format.html { redirect_to new_group_remit_batch_beneficiary_path(@group_remit, @batch), notice: "Member dependent was successfully created." }
          end
        else
          if member_dependent_params[:claims]
            format.html { render :new_beneficiary_claims, status: :unprocessable_entity }
          else
            format.html { render :new_beneficiary, status: :unprocessable_entity }
          end
        end
      end

    end
  end

  def create
    @member_dependent = @member.member_dependents.find_or_initialize_by(
      first_name: member_dependent_params[:first_name],
      last_name: member_dependent_params[:last_name],
      birth_date: member_dependent_params[:birth_date]
    )

    respond_to do |format|
      if @member_dependent.persisted?
        format.html { redirect_to new_group_remit_batch_dependent_path(@group_remit, @batch, error: true), notice: "Dependent already exists" }
      else
        @member_dependent = @member.member_dependents.build(member_dependent_params)

        if @member_dependent.save
          format.html { redirect_to new_group_remit_batch_dependent_path(@group_remit, @batch), notice: "Dependent was successfully created" }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @member_dependent.update(member_dependent_params)
        format.html { redirect_to member_dependents_path(@member), notice: "Member dependent was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @member_dependent.destroy
    respond_to do |format|
      format.html { redirect_to member_member_dependents_path(@member), notice: "Member dependent was successfully destroyed." }
    end
  end

  private

  def set_group_remit_batch
    @group_remit = GroupRemit.find(params[:group_remit_id])
    @batch = @group_remit.batches.find(params[:batch_id])
  end

  def set_member
    set_group_remit_batch
    @coop_member = @batch.coop_member
    @member = @coop_member.member
  end

  def set_member_dependent
    @member_dependent = @member.member_dependents.find(params[:id])
  end

  def member_dependent_params
    params.require(:member_dependent).permit(:last_name, :first_name, :middle_name, :suffix, :birth_date, :relationship, :claims)
  end

  def check_userable_type
    unless current_user.userable_type == "CoopUser"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
