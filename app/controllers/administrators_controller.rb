class AdministratorsController < ApplicationController
  before_action :admin_user, only: [:index, :create, :edit, :update, :destroy] 

  def index
    @user = User.find(params[:user_id])
    @administrators = Administrator.all

  end

  def create
    # byebug
    @administrator = Administrator.new(administrator_params)
    if @administrator.save
      
      flash[:success] = '新規作成に成功しました。'
      redirect_to user_administrators_url(current_user)
    else
      redirect_to user_administrators_url(current_user)
    end
  end

  def edit
    @administrator = Administrator.find(params[:id])
  end
  def update
    # byebug
    @administrator = Administrator.find(params[:id])
    if @administrator.update_attributes(update_administrator_params)
    flash[:success] = "更新しました。"
    redirect_to user_administrators_url(current_user)
    else
      redirect_to edit_user_administrator_path(@user, administrator)
    end
  end

  def destroy
    @administrator = Administrator.find(params[:id])
    @administrator.destroy
    flash[:success] = "データを削除しました。"
    redirect_to user_administrators_url(current_user)
  end

  private
    def administrator_params
      params.permit(:notice, :user_id)
    end

    def update_administrator_params
      
      params.require(:administrator).permit(:notice, :id, :user_id)
    end

  
  
  
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
    # 管理者
    def admin_or_correct_user
      # byebug
      # @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        # byebug
        # flash[:danger] = "編集権限がありません。"
        flash[:danger] = "不正なアクセスです。"
        redirect_to(root_url)
      end
    end

end
