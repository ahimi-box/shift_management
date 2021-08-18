class ShiftsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :edit_one_month, :update_one_month, :apply_edit]
  before_action :logged_in_user, only: [:edit, :update, :edit_one_month]
  before_action :set_one_month, only: [:apply_edit, :edit, :edit_one_month]
  before_action :set_one_day, only: :show

  def index
    @user = User.find(params[:user_id])
    @shifts = Shift.all.order(worked_on: "DESC")
    @shift = Shift.new
    @administrators = Administrator.all
    # byebug
  end
  
  # def new
  #   @user = User.find(params[:user_id])
  #   @shift = Shift.new
  # end

  def show
    # byebug
    @user = User.find(params[:user_id])
    @shift = Shift.find(params[:id])
    # byebug
    @groups = Shift.all.where(worked_on: params[:date].to_date).group_by(&:user_id)
    # @groups = Shift.all.where(worked_on: @first_day..@last_day).order(:worked_on).group_by(&:user_id)
    # byebug
    @timeline = Shift.where(worked_on: params[:date].to_date).order(:user_id).map do |project| 
      # byebug
      
      project1 = User.find(project.user_id)
      # byebug
      if project.desired_attendance_time.nil? && project.desired_leave_time.nil?
        project.desired_attendance_time = "09:00"
        project.desired_leave_time = "09:00"
      end  
      # byebug       
        [project1.name, intime(project), outtime(project)]
    end
  end

  # def create
    # byebug
    # @user = User.find(params[:user_id])
    # Shift.create(shift_parameter)
    # redirect_to user_shifts_url(date: params[:start_date])
    # redirect_to user_url(@user)
    # redirect_to user_path
  # end

  # def destroy
  #   @user = User.find(params[:user_id])
  #   @shift = Shift.find(params[:id])
  #   @shift.destroy
  #     redirect_to user_shifts_url(date: params[:start_date])
  #     # redirect_to user_url(date: params[:date])
  #     flash[:success] = "削除しました。"
  #   # redirect_to user_path, notice:"削除しました"
  # end

  def edit
    @user = User.find(params[:user_id])
    # byebug
    @shift = Shift.find_by(user_id: params[:user_id])
    @shifts = @user.shifts.where(worked_on: @first_day..@last_day).order(:worked_on)
    # @groups = Shift.find(params[:id])
    # @groups = Shift.all.group_by(&:user_id)
  end

  def update
    @user = User.find(params[:id])
    @shift = @user.shifts.find_by(user_id: params[:user_id])
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      shift_edit_params.each do |id, item1|
        # byebug
        item1.each do |id,item2|

          shift = Shift.find(id)
          # byebug
          shift.update_attributes!(item2)
        end
      end
    end
    flash[:success] = "編集しました。"
    redirect_to apply_edit_user_shift_url(@user, date: params[:date])
    # redirect_to user_shifts_path(@user, date: params[:date])
    # users/show画面
    # redirect_to user_url(date: params[:date])

    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    # redirect_to shift_edit_one_month_user_url(date: params[:date])
    render 'shifts/edit'

    # byebug
    # if @shift.update_attributes!(shift_edit_params)
    #   redirect_to user_shift_url(@user,@shift, date: @first_day)
    # #   # redirect_to user_url(date: params[:date])
    #   flash[:success] = "編集しました。"
    # #   # redirect_to user_path, notice: 
    # else
    #   render 'shifts/show'
    # #   # render 'edit'
    # end
  end

  def apply_edit
    @user = User.find(params[:user_id])
    @shift = Shift.find(params[:id])
    @groups = Shift.all.where(worked_on: @first_day..@last_day).order(:worked_on).group_by(&:user_id)
    # @groups = @user.shifts.all.group_by(&:user_id)
    @administrators = Administrator.all
  end
  
  def apply_update
    byebug
  end

  def edit_one_month
    @administrators = Administrator.all
  end
  
  def update_one_month
    # byebug
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      shifts_params.each do |id, item1|
                # byebug
        item1.each do |id,item2|
        # byebug
          item2[:desired_attendance_time] = item2[:started_at]
          item2[:desired_leave_time] = item2[:finished_at]
          shift = Shift.find(id)
          # byebug
          shift.update_attributes!(item2)
        end
      end
    end
    flash[:success] = "シフトの申請を更新しました。"
    redirect_to user_shifts_path(@user, date: params[:date])
    # users/show画面
    # redirect_to user_url(date: params[:date])

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    redirect_to edit_one_month_user_shift_url(@user,@user, date: params[:date])
  end

  private
  def intime(project)
    "#{project.worked_on.year}-#{project.worked_on.month}-#{project.worked_on.day} #{project.desired_attendance_time.strftime('%H:%M')}"
    # "#{project.started_at.strftime('%H:%M')}"
  end
  
  def outtime(project)
    "#{project.worked_on.year}-#{project.worked_on.month}-#{project.worked_on.day} #{project.desired_leave_time.strftime('%H:%M')}"
    # "#{project.finished_at.strftime('%H:%M')}"
  end

    # シフトの申請。
    def shifts_params
      # params.require(:shifts).permit(shifts: [:start_time, :started_at, :finished_at, :desired_attendance_time, :desired_leave_time, :user_memo, :admin_memo])
      params.permit(shifts: [:start_time, :started_at, :finished_at, :desired_attendance_time, :desired_leave_time, :user_memo])
      
      # params.require(:user).permit(shifts: [:started_at, :finished_at, :user_memo, :desired_attendance_time, :desired_leave_time])
      
      # [:attendances]
      # params.permit(administrator_attributes:[:notice, :id, :user_id])
    end
    
    # admin  申請編集
    def shift_edit_params
      params.require(:shift).permit(shift: [:desired_attendance_time, :desired_leave_time, :admin_memo])
    end

    # カレンダー
    # def shift_parameter
    #   # start_time = params[:shift]["start_time(1i)"] + "-" + params[:shift]["start_time(2i)"] + "-" + params[:shift]["start_time(3i)"] + " " + params[:shift]["start_time(4i)"] + ":"+ params[:shift]["start_time(5i)"]
    #   start_time = params[:shift]["start_time(1i)"] + "-" + params[:shift]["start_time(2i)"] + "-" + params[:shift]["start_time(3i)"]
    #   # worked_on = params[:shift]["start_time(1i)"] + "-" + params[:shift]["start_time(2i)"] + "-" + params[:shift]["start_time(3i)"]
    #   started_at = params[:shift]["started_at(4i)"] + ":" + params[:shift]["started_at(5i)"]
    #   finished_at = params[:shift]["finished_at(4i)"] + ":" + params[:shift]["finished_at(5i)"]
      
    #   # params.require(:shift).permit(:worked_on, :started_at, :finished_at, :user_memo, :start_time)
      
    #   # params.require(:shift).permit(:user_memo, worked_on: worked_on, started_at: started_at, finished_at: finished_at,  start_time: start_time)
      
    #   params.require(:shift).permit(:user_memo, :admin_memo).merge(started_at: started_at, finished_at: finished_at,  start_time: start_time, user_id: params[:user_id]) 
    #   # params.require(:shift).permit(:user_memo, :admin_memo).merge(started_at: started_at, finished_at: finished_at,  start_time: start_time, user_id: params[:user_id]) 
      
      
    # end
end
