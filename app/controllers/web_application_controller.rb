class WebApplicationController < ActionController::Base
  layout 'application'
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :ensure_admin_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def ensure_admin_user
    unless current_user&.admin?
      if current_user
        # User is logged in but not an admin
        sign_out current_user
        redirect_to new_user_session_path, alert: "Admin access required. Please sign in with an admin account."
      else
        # User is not logged in
        redirect_to new_user_session_path, alert: "Please sign in to access the admin interface."
      end
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :organization_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
