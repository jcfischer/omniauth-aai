class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # include Omniauth::HasCurrentUser
  has_current_user
end
