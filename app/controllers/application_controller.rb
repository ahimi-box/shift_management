class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforeフィルター

  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
  
  

  # ログイン済みのユーザーか確認します。
  def logged_in?
    !current_user.nil?
  end
  def logged_in_user
    unless logged_in?
      # store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    # redirect_to(root_url) unless current_user?(@user)
    redirect_to(root_url) unless current_user == @user
    # flash[:danger] = "不正なアクセスです。"
  end

  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
    # flash[:danger] = "不正なアクセスです。"
  end
  
  
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    # @first_day = Date.current.beginning_of_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @shifts = @user.shifts.where(worked_on: @first_day..@last_day)

    unless one_month.count == @shifts.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.shifts.create!(worked_on: day) }
      end
        @shifts = @user.shifts.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end


  # 一日
  def set_one_day
    # @first_day = Date.current.beginning_of_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @shifts = @user.shifts.where(worked_on: @first_day..@last_day)

    unless one_month.count == @shifts.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.shifts.create!(worked_on: day) }
      end
        @shifts = @user.shifts.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

protected
def configure_permitted_parameters
  added_attrs = [
    :employee_number, 
    :name,
    :email,
    :password,
    :password_confirmation,
  ]
  added_attrs2 = [ 
    :email,
    :password,
    :password_confirmation,
  ]
  # アカウント登録
  devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  # アカウント更新
  devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  # ログイン
  devise_parameter_sanitizer.permit :sign_in, keys: added_attrs2

  # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
end

private 
  def after_sign_in_path_for(resource)
    # ログイン後に遷移するpathを設定
    # byebug
    #  current_user = @user
    # mypage_root_path user
    if current_user.admin
      # users/index
      # users_index_path
      users_path
    else
      # users/show
      user_path(current_user)
      # redirect_to @user
      # user_path(@user)
    end
    
  end
  def after_sign_out_path_for(resource)

    # new_user_session_path # ログアウト後に遷移するpathを設定
    # if resource_or_scope == :customer
      root_path
    # elsif resource_or_scope == :organizer
      # new_organizer_session_path
    # end
  end  
  
end


