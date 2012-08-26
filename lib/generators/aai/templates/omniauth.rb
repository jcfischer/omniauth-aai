Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
    provider :developer, {
      :uid_field => :'persistent-id',
      :fields => OmniAuth::Strategies::Aai::DEFAULT_FIELDS,
      :extra_fields => OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
    } 
  else
    provider :aai
  end
end

class ApplicationController < ActionController::Base
  # Get the current user
  def current_user() session[:current_user]; end
  # Set the current user
  def current_user=(user) session[:current_user] = user; end
  # Authenticate User
  def authenticate!
    return if authenticated?
    session[:return_to] = request.url
    if Rails.env.development?
      redirect_to "/auth/developer"
    else
      redirect_to "/auth/aai"
    end
  end
  # User authenticated?
  def authenticated?
    return true if self.current_user
    return false
  end
end