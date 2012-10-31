class ApplicationController < ActionController::Base
  protect_from_forgery

  has_current_user
end
