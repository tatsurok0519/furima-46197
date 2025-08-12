class ApplicationController < ActionController::Base
  before_action :basic_auth
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Userモデルにnicknameなどのカラムを追加した場合に備えて設定します。
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == 'ryoyayuki' && password == '11223'
    end
  end
end
