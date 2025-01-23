class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログアウト後のリダイレクト先を設定
  def after_sign_out_path_for(resource_or_scope)
    root_path # トップページにリダイレクト
  end

  protected

  # Deviseで許可するパラメーターを設定
  def configure_permitted_parameters
    # サインアップ時に username と avatar を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
    # アカウント更新時に username と avatar を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end
end
