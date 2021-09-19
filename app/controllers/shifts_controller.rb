class ShiftsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :edit_one_month, :update_one_month, :apply_edit]
  # before_action :logged_in_user, only: [:edit, :update, :edit_one_month]
  # # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  before_action :correct_user, only: [ :edit_one_month, :update_one_month]
  before_action :correct_user2, only: [:index]
  before_action :set_one_month, only: [:apply_edit, :edit, :edit_one_month]
  before_action :set_one_day, only: :show
  before_action :admin_user, only: [:apply_edit, :edit]
  before_action :authenticate_user!, only: [:edit, :update, :edit_one_month, :apply_edit]

  def index
    @user = User.find(params[:user_id])
    @shifts = Shift.all.order(worked_on: "DESC")
    @shift = Shift.new
    @administrators = Administrator.all 
    # byebug
  end
  
  def show
    # byebug
    @user = User.find(params[:user_id])
    @shift = Shift.find(params[:id])
    # byebug
    @timeline = Shift.eager_load(:user).where(shifts: {worked_on: params[:date].to_date}).order("users.classification").map do |project|
      # byebug
      project1 = User.find(project.user_id)
      # byebug
      if project.desired_attendance_time.nil? && project.desired_leave_time.nil?
        project.desired_attendance_time = "09:00"
        project.desired_leave_time = "09:00"
      end 
        [project1.name, intime(project), outtime(project)]
    end
    # byebug

  end

  def edit
    @user = User.find(params[:user_id])
    # byebug
    @shift = Shift.find_by(user_id: params[:user_id])
    @shifts = @user.shifts.where(worked_on: @first_day..@last_day).order(:worked_on)
    
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

    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
    render 'shifts/edit'

  end

  
  def apply_edit
    @user = User.find(params[:user_id])
    @shift = Shift.find(params[:id])
    # byebug
    # @groups = User.eager_load(:shifts).all.where(shifts: {worked_on: @first_day..@last_day}).order(:classification).group_by(&:classification)
    @groups = User.eager_load(:shifts).all.where(shifts: {worked_on: @first_day..@last_day}).order("shifts.worked_on", :classification).group_by(&:classification)
    @administrators = Administrator.all
    
    # csv出力
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "#{@first_day.strftime('%Y年%m月')}シフト一覧情報.csv", type: :csv
      end
    end   
  end
  
  def apply_update
    # byebug
    @user = User.find(params[:user_id])
    @shift = @user.shifts.find(params[:id])
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      apply_update_params.each do |id, item1|
        item1.each do |id, item2|
          if item2[:apply_check] == "true"
            shift = Shift.find(id)
            shift.update_attributes!(item2)
          end 
        end
      end
      flash[:success] = "シフトの決定を送信しました。"
      # byebug
      redirect_to apply_edit_user_shift_path(@user, date: params[:date])
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、申請をキャンセルしました。"
      redirect_to apply_edit_user_shift_path(@user, date: params[:date])
    end  
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
          shift = Shift.find(id)
          if (item2[:desired_attendance_time] == "") && (item2[:desired_leave_time] == "")
            item2[:desired_attendance_time] = item2[:started_at]
            item2[:desired_leave_time] = item2[:finished_at]
          end
          # item2[:desired_attendance_time] = item2[:started_at]
          # item2[:desired_leave_time] = item2[:finished_at]
          
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
      
    end
    
    # admin  申請編集
    def shift_edit_params
      params.require(:shift).permit(shift: [:desired_attendance_time, :desired_leave_time, :admin_memo])
    end

    def apply_update_params
      params.require(:shift).permit(apply_edit: [:determined_arrival_time, :decided_leaving_time, :apply_check])
    end

  private
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user2
      # byebug
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user == @user
      # flash[:danger] = "不正なアクセスです。"
    end

    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
      # flash[:danger] = "不正なアクセスです。"
    end
     
end
