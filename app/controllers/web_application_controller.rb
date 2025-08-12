class WebApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :ensure_admin_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def ensure_admin_user
    unless current_user&.admin?
      redirect_to new_user_session_path
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
