class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, ]
  # before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:show, :edit, :update]   
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  # 管理者権限
  before_action :admin_or_correct_user, only: :index
  before_action :authenticate_user!, only: [:show, :index, :destroy, :edit_basic_info, :update_basic_info,]
   

  def index
    # @users = User.all
    # @users = User.paginate(page: params[:page],per_page: 10)
    # # 条件分岐
    @users = if params[:search].present?
        # searchされた場合は、原文+.where('name LIKE ?', "%#{params[:search]}%")を実行
      User.paginate(page: params[:page],per_page: 10).search(params[:search]).order(:classification)
    else
      #searchされていない場合は、原文そのまま
      User.paginate(page: params[:page],per_page: 10).order(:classification)
    end
  end

  def show
    # if @user.admin
    #   redirect_to users_index_url
    # end
    # @worked_sum = @attendances.where.not(started_at: nil).count
    # byebug
    @shifts = Shift.all
    @administrators = Administrator.all
  end

  # def new
  #   @user = User.new
  # end
  
  # def create
  #   # byebug
  #   @user = User.new(user_params)
  #   if @user.save
  #     log_in @user
  #     flash[:success] = '新規作成に成功しました。'
  #     redirect_to @user
  #   else
  #     render :new
  #   end
  # end
  
  # def edit
  # end
  
  # def update
  #   if @user.update_attributes(user_params)
  #     flash[:success] = "ユーザー情報を更新しました。"
  #     redirect_to @user
  #   else
  #     render :edit
  #   end
  # end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  private
  
    # def user_params
    #   params.require(:user).permit(:employee_number, :name, :email, :employment_status, :password, :password_confirmation)
    # end
    
    def basic_info_params
      params.require(:user).permit(:classification, :name, :email, :employment_status, :employee_number, :password, :basic_time, :basic_startwork_time, :basic_finishwork_time)
    end

    # 管理者
    def admin_or_correct_user
      # byebug
      # @user = User.find(params[:id]) if @user.blank?
      # unless current_user?(@user) || current_user.admin?
      unless current_user == @user || current_user.admin?  
        # flash[:danger] = "編集権限がありません。"
        flash[:danger] = "不正なアクセスです。"
        redirect_to(root_url)
      end
    end
  
end
