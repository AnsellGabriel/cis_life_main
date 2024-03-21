class BatchRemarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_batch_remark, only: %i[ show edit update destroy ]

  # GET /batch_remarks
  def index
    @batch_remarks = BatchRemark.all
  end

  # GET /batch_remarks/1
  def show
  end

  # GET /batch_remarks/new
  def new
    @batch = check_class(params[:batch_type], params[:ref])

    @batch_remark = @batch.batch_remarks.build
    @ref = params[:ref]
    # @batch_remark = BatchRemark.new
    @title = case params[:batch_status]
      when "Pending" then "Pending Batch"
      when "Deny" then "Deny Batch"
      when "MD" then "Med Dir"
      when "New" then "New Remark"
      when "For reconsideration" then "Request for reconsideration"
             end

    @batch_status = params[:batch_status]
    @rem_status = remark_status(@batch_status)
    @process_coverage = ProcessCoverage.find(params[:pro_cov])

    # @batch_type = params[:batch_type].nil? ? "Batch" : params[:batch_type]
  end

  def form_md

    # binding.pry

    #  @batch_status = "MD"

    #  @rem_status = :md_reco
    #  @process_coverage = @batch.group_remit.process_coverage

    #  @batch = Batch.find(params[:batch])
    #  @batch_remark = @batch.batch_remarks.build

  end

  # GET /batch_remarks/1/edit
  def edit
  end

  # POST /batch_remarks
  def create
    # @batch_remark = BatchRemark.new(batch_remark_params)
    unless params[:batch_remark][:status] == "md_reco"
      @batch = check_class(params[:batch_type], params[:batch_id])
    else
      @batch = check_class(params[:batch_remark][:remarkable_type], params[:batch_remark][:remarkable_id])
    end
    @batch_remark = BatchRemark.new(batch_remark_params)
    @batch_remark.user_type = current_user.userable_type
    @batch_remark.user_id = current_user.userable_id
    # @batch_remark.remarkable_id = @batch.id
    # @batch_remark.remarkable_type = @batch.class.name
    @ref = @batch.id
    @batch_remark.remarkable = @batch
    @batch_status = params[:batch_remark][:batch_status]
    @rem_status = remark_status(@batch_status)

    @process_coverage = ProcessCoverage.find_by(id: params[:batch_remark][:process_coverage])&.id
    @pc = ProcessCoverage.find(params[:batch_remark][:process_coverage])
        
    if !params[:batch_type] == "BatchDependent" && params[:batch_remark][:status] == "denied" && (@batch.batch_dependents.for_review.count > 0 || @batch.batch_dependents.pending.count > 0)
      redirect_to process_coverage_path(@process_coverage), alert: "Please check pending and/or for review dependent(s) for that coverage."
    else

      respond_to do |format|
        # if @batch_remark.remark.empty? && @batch_remark.batch_status == "For reconsideration" && params[:batch_type] == "Batch"
        #   format.html { render :new, alert: "Unable to create empty request" }
        # elsif @batch_remark.remark.empty? && @batch_remark.batch_status == "For reconsideration" && params[:batch_type] == "BatchDependent"
        #   format.html { render :new, alert: "Unable to create empty request" }
        # elsif @batch_remark.remark.empty?
        #   # format.html { return redirect_to process_coverage_path(@process_coverage), alert: "Unable to create empty request."}
        #   format.html { render :new, alert: "Unable to create empty request" }

        # end
        if @batch_remark.save

          # byebug
          # redirect_to @batch_remark, notice: "Batch remark was successfully created."
          if params[:batch_remark][:batch_status] == "Pending"
            # format.html { redirect_to pending_batch_process_coverage_path(id: @process_coverage, batch: @batch)}
            @batch.update(insurance_status: :pending)
            if params[:batch_type] == "BatchDependent"
              format.html { redirect_to dependent_remarks_path(
                batch_dependent_id: @batch.id,
                group_remit_id: @batch.batch.group_remits.find_by(type: "Remittance").id,
                batch_id: @batch.batch.id,
                process_coverage_id: @process_coverage,
                for_und: true) }
            else
              format.turbo_stream
            end
            # format.html { redirect_to modal_remarks_process_coverage_path(@process_coverage, batch: @batch)}
          elsif params[:batch_remark][:batch_status] == "Deny"
                        
            # format.html { redirect_to deny_batch_process_coverage_path(id: @process_coverage, batch: @batch)}
            @batch.update(insurance_status: :denied)
            @pc.update(approved_count: @pc.count_batches("approved"), denied_count: @pc.count_batches("denied"))
            if params[:batch_type] == "BatchDependent"
              format.html { redirect_to dependent_remarks_path(
                batch_dependent_id: @batch.id,
                group_remit_id: @batch.batch.group_remits.find_by(type: "Remittance").id,
                batch_id: @batch.batch.id,
                process_coverage_id: @process_coverage,
                for_und: true) }
            else
              format.turbo_stream
            end
            #   format.html { redirect_to pending_batch_process_coverage_path(id: @process_coverage.id, batch: @batch, batch_type: params[:batch_remark][:batch_type])}
            # elsif params[:batch_remark][:batch_status] == "Deny"
            #   format.html { redirect_to deny_batch_process_coverage_path(id: @process_coverage.id, batch: @batch, batch_type: params[:batch_remark][:batch_type])}
          elsif params[:batch_remark][:batch_status] == "New"
            if params[:batch_type] == "BatchDependent"
              format.html { redirect_to dependent_remarks_path(
                batch_dependent_id: @batch.id,
                group_remit_id: @batch.batch.group_remits.find_by(type: "Remittance").id,
                batch_id: @batch.batch.id,
                process_coverage_id: @process_coverage,
                for_und: true) }
            else

              format.html { redirect_to modal_remarks_process_coverage_path(@process_coverage, batch: @batch, batch_type: @batch.class.name)}
            end

          elsif params[:batch_remark][:batch_status] == "MD"
            @group_remit = @batch.group_remits.find_by(type: "Remittance")
            # format.html { redirect_to all_health_decs_group_remit_batches_path(@group_remit.process_coverage), notice: "Recommendation created." }
            format.html { redirect_to med_directors_home_path, notice: "Recommendation created." }
          elsif params[:batch_remark][:batch_status] == "For reconsideration"

            if params[:batch_type] == "BatchDependent"
              @batch.update(insurance_status: :for_reconsideration)
              format.html { redirect_to dependent_remarks_path(
                batch_dependent_id: @batch.id,
                group_remit_id: @batch.batch.group_remits.find_by(type: "Remittance"),
                batch_id: @batch.batch.id, coop: true) }
            else
              @batch.update(status: :for_reconsideration)
              if @batch.class.name == "LoanInsurance::Batch"
                format.html { redirect_to modal_remarks_loan_insurance_batch_path(@batch, insurance_status: :denied) }
              else
                @group_remit = @batch.group_remits.find_by(type: "Remittance")
                format.html { redirect_to modal_remarks_group_remit_batch_path(@group_remit, @batch, insurance_status: :denied) }
              end
            end

          else
            format.html { redirect_to batch_remark_url(@batch_remark), notice: "Batch remark was successfully created." }
            format.json { render :show, status: :created, location: @batch_remark }
          end

        else

          # if params[:batch_remark][:batch_status] == "For reconsideration"
          #   format.html { render :new, status: :unprocessable_entity }
          # else
          format.html { render :new, status: :unprocessable_entity }
          # format.json { render json: @batch_remark.errors, status: :unprocessable_entity }
          # format.turbo_stream { render :form_update, status: :unprocessable_entity }
          # end

        end

      end

    end

  end

  # PATCH/PUT /batch_remarks/1
  def update
    if @batch_remark.update(batch_remark_params)
      redirect_to @batch_remark, notice: "Batch remark was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /batch_remarks/1
  def destroy
    @batch_remark.destroy
    redirect_to batch_remarks_url, notice: "Batch remark was successfully destroyed."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_batch_remark
    @batch_remark = BatchRemark.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def batch_remark_params
    params.require(:batch_remark).permit(:batch_id, :remark, :status, :user_id, :user_type, :batch_status, :process_coverage, :batch_type)
  end

  def check_class(class_name, id)
    case class_name
    when "Batch"
      Batch.find(id)
    when "BatchDependent"
      BatchDependent.find(id)
    when "LoanInsurance::Batch"
      LoanInsurance::Batch.find(id)
    end
  end

  def remark_status(batch_status)
    case batch_status
      when "Pending" then :pending
      when "Deny" then :denied
      when "MD" then :md_reco
      when "For reconsideration" then :request
    end
  end
end
