class ApplicationController < ActionController::Base
  has_current_user
  protect_from_forgery with: :exception
end
