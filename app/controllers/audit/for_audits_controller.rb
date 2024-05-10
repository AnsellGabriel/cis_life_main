class Audit::ForAuditsController < ApplicationController
  def index
    @vouchers = Accounting::Voucher.pending_for_audit
    @pagy, @vouchers = pagy(@vouchers, items: 10)
  end

  def approve
    case params[:e_t]
      when "da" then @voucher = Accounting::DebitAdvice.find(params[:id])
      when "cv" then @voucher = Accounting::Check.find(params[:id])
    end

    ActiveRecord::Base.transaction do
      @voucher.update!(audit: :approved, audited_by: current_user.id)
      if @voucher.voucher_request.requestable.is_a?(Claims::ProcessClaim)
        claim_track = @voucher.voucher_request.requestable.process_track.build
        claim_track.route_id = 15
        claim_track.user_id = current_user.id
        claim_track.save!
      end
    end

    redirect_to accounting_check_path(@voucher), notice: "Check Voucher audited and approved"
  end
end
