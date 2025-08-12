class Users::SessionsController < Devise::SessionsController
  protected

  # Redirect to organizations after sign in
  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_organizations_path
    else
      # Regular users shouldn't be able to sign in to web interface,
      # but if they do, redirect them back to sign in
      sign_out resource
      new_user_session_path
    end
  end

  # Redirect to organizations after sign out
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
