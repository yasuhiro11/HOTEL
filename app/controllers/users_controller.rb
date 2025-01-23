class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'ユーザーが見つかりません'
  end

  def update
    Rails.logger.debug "Starting account update process"
    Rails.logger.debug "Params received: #{params.inspect}"
  
    if current_password_invalid?
      Rails.logger.debug "Current password validation failed"
      flash.now[:alert] = "現在のパスワードが正しくありません。"
      render :edit and return
    end
  
    successfully_updated = if password_provided?
                             @user.update_with_password(account_update_params)
                           else
                             @user.update_without_password(account_update_params.except(:current_password))
                           end
  
    if successfully_updated
      Rails.logger.debug "Account update successful"
      flash[:notice] = "アカウント情報が更新されました。"
      bypass_sign_in(@user)
      redirect_to root_path
    else
      Rails.logger.debug "Account update failed: #{@user.errors.full_messages}"
      flash.now[:alert] = "更新に失敗しました。入力内容を確認してください。"
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
    Rails.logger.debug "@user: #{@user.inspect}"
  end

  def account_update_params
    params.require(:user).permit(:name, :bio, :introduction, :avatar, :email, :password, :password_confirmation, :current_password)
  end

  def current_password_invalid?
    return false if @user.nil? || account_update_params[:current_password].blank?

    !@user.valid_password?(account_update_params[:current_password])
  end

  def password_provided?
    account_update_params[:password].present?
  end
end