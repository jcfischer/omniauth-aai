class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # if Rails.env.production?
  #   protect_from_forgery with: :exception
  # else
  #   protect_from_forgery with: :null_session
  # end
  protect_from_forgery with: :exception
  has_current_user
end
