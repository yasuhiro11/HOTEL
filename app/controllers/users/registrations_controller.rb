module Users
    class RegistrationsController < Devise::RegistrationsController
      def update
        Rails.logger.debug "Entering update action"
  
        self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  
        if profile_update_request?
          handle_profile_update
        else
          handle_account_update
        end
      end
  
      private
  
      # プロフィール更新リクエストかどうかを判定
      def profile_update_request?
        params[:user].key?(:avatar) || params[:user].key?(:name) || params[:user].key?(:bio)
      end
  
      # プロフィール更新の処理
      def handle_profile_update
        Rails.logger.debug "Profile update request detected"
        if resource.update(profile_update_params)
          Rails.logger.debug "Profile update successful"
          flash[:notice] = "プロフィールが正常に更新されました。"
          redirect_to user_profile_path(resource) # プロフィール更新後のリダイレクト先
        else
          Rails.logger.debug "Profile update failed: #{resource.errors.full_messages}"
          flash[:alert] = "プロフィールの更新に失敗しました。以下のエラーを確認してください。"
          render :edit # プロフィール更新失敗時に再度編集画面を表示
        end
      end
  
      # アカウント更新の処理
      def handle_account_update
        Rails.logger.debug "Account update params: #{account_update_params.inspect}"
        Rails.logger.debug "Provided current_password: #{account_update_params[:current_password]}"
        Rails.logger.debug "Encrypted password in database: #{resource.encrypted_password}"
        
        # 明示的なパスワード検証
        if resource.valid_password?(account_update_params[:current_password])
          Rails.logger.debug "Current password is valid."
  
          # バリデーションをスキップしてパスワードを強制的に保存
          resource.password = account_update_params[:password]
          resource.password_confirmation = account_update_params[:password_confirmation]
  
          if resource.save(validate: false)
            Rails.logger.debug "Password updated successfully with forced save."
            flash[:notice] = "アカウント情報が正常に更新されました。"
            redirect_to defined?(account_settings_path) ? account_settings_path(resource) : edit_user_registration_path
          else
            Rails.logger.debug "Forced save failed: #{resource.errors.full_messages.join(', ')}"
            flash[:alert] = "アカウント情報の更新に失敗しました。"
            render :edit # 再度編集画面を表示
          end
        else
          Rails.logger.debug "Current password is invalid."
          flash[:alert] = "現在のパスワードが正しくありません。"
          render :edit # 再度編集画面を表示
        end
      end
  
      # プロフィール更新時に許可するパラメータ
      def profile_update_params
        params.require(:user).permit(:avatar, :name, :bio)
      end
  
      # アカウント更新時に許可するパラメータ
      def account_update_params
        params.require(:user).permit(:name, :introduction, :avatar, :email, :password, :password_confirmation, :current_password)
      end
    end
  end