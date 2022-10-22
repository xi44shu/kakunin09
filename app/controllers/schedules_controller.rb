class SchedulesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :copy]
  before_action :get_week, only: [:index, :new, :show, :edit, :update, :copy]
  before_action :get_calenar, only: [:index, :new, :show, :edit, :update, :copy]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def index
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
        @schedule.delete
      redirect_to root_path
  end

  def copy
    @schedule = Schedule.find(params[:id]).dup
  end

  private

  def schedule_params
    params.require(:schedule).permit(:scheduled_date, :time_zone_id, :team_id, :size_id, :mie_id, :accuracy_id, :first_contact_id, :trading_company_id, :prime_contractor, :content, :start_time_id).merge(user_id: current_user.id)
  end  

  def get_week
    # カレンダーに日付データ曜日を持たせる
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    @todays_date = Date.today

    @week_days = []

    7.times do |x|

      wday_num = Date.today.wday + x
      if  wday_num >= 7
        wday_num = wday_num -7
      end

      today_days = { scheduled_date:(@todays_date + x), month: (@todays_date + x).month, date: (@todays_date + x).day, wday:  wdays[wday_num]}

      @week_days.push(today_days)
    end
  end

  def get_calenar
    # カレンダー表示に必要なデータ
    @teams = Team.where(work: '1')
    @schedules = Schedule.where(scheduled_date: @todays_date..@todays_date + 6)
  end

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

end
