class Treasury::DebitAdvicesController < ApplicationController
  # GET /treasury/debit_advices
  def index
    @q = Accounting::DebitAdvice.approved.order(created_at: :desc).ransack(params[:q])
    @debit_advices = @q.result

    @pagy, @debit_advices = pagy(@debit_advices, items: 10)
  end
end
