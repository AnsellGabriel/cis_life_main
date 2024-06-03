module BatchesLoader
  extend ActiveSupport::Concern

  included do
    def load_batches
      batches_eager_loaded = @group_remit.batches.includes(
        {coop_member: :member, batch_dependents: :member_dependent, batch_beneficiaries: :member_dependent},
        :batch_health_decs,
        :agreement_benefit
      )

      if params[:batch_filter].present?
        @f_batches = batches_eager_loaded.filter_by_member_name(params[:batch_filter].upcase).order(created_at: :desc)
      elsif params[:batch_beneficiary_filter].present?
        @f_batches = @group_remit.batches_without_beneficiaries.order(created_at: :desc)
      elsif params[:batch_health_dec_filter].present?
        @f_batches = @group_remit.batches_without_health_dec.order(created_at: :desc)
      elsif params[:incorrect_premiums].present?
        @f_batches = @group_remit.batches_with_incorrect_prem.order(created_at: :desc)
      elsif params[:rank_filter].present?
        @f_batches = @group_remit.batches.joins(:agreement_benefit).where(agreement_benefits: params[:rank_filter])
      elsif params[:insurance_status].present?
        case params[:insurance_status]
        when "approved"
          @f_batches = batches_eager_loaded.where(insurance_status: :approved)
        when "pending"
          @f_batches = batches_eager_loaded.where(insurance_status: :pending)
        when "denied"
          @f_batches = batches_eager_loaded.where(insurance_status: :denied)
        when "for_review"
          @f_batches = batches_eager_loaded.where(insurance_status: :for_review)
        when "for_reconsideration"
          @f_batches = batches_eager_loaded.where(status: :for_reconsideration)
        end
      else
        @f_batches = batches_eager_loaded
      end
    end

    def paginate_batches
      @pagy, @batches = pagy(@f_batches, items: 10)
    end
  end

end
