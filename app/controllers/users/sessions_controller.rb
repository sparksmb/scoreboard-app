class Users::SessionsController < Devise::SessionsController
  protected

  # Redirect to organizations after sign in
  def after_sign_in_path_for(resource)
    organizations_path  # Both admin and regular users go to organizations (controller handles redirection)
  end

  # Redirect to organizations after sign out
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
