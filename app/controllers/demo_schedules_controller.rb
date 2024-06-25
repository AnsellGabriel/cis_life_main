class DemoSchedulesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :set_demo_schedule, only: %i[ show edit update destroy ]

  # GET /demo_schedules
  def index
    @demo_schedules = DemoSchedule.all
  end

  # GET /demo_schedules/1
  def show
  end

  # GET /demo_schedules/new
  def new
    @demo_schedule = DemoSchedule.new
  end

  # GET /demo_schedules/1/edit
  def edit
  end

  # POST /demo_schedules
  def create
    @demo_schedule = DemoSchedule.new(demo_schedule_params)
    @demo_schedule.status = 0
    if @demo_schedule.save
      if current_user
        redirect_to authenticated_root_path, notice: "Demo schedule was successfully created."
      else
        redirect_to unauthenticated_root_path, notice: "Demo schedule was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
      # format.turbo_stream { render :form_update, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /demo_schedules/1
  def update
    if @demo_schedule.update(demo_schedule_params)
      redirect_to @demo_schedule, notice: "Demo schedule was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /demo_schedules/1
  def destroy
    @demo_schedule.destroy
    redirect_to demo_schedules_url, notice: "Demo schedule was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_demo_schedule
      @demo_schedule = DemoSchedule.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def demo_schedule_params
      params.require(:demo_schedule).permit(:cooperative, :name, :contact_no, :email, :demo_date, :time_slot, :remarks, :status, :method)
    end
end
