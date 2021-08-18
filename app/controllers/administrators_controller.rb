class AdministratorsController < ApplicationController
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
    byebug
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

  def administrator_params
  params.permit(:notice, :user_id)
  end

  def update_administrator_params
    
  params.require(:administrator).permit(:notice, :id, :user_id)
  end

end
