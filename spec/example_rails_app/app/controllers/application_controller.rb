class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    session[:user]
  end

  def current_user=(user)
    session[:user] = user
  end


  def authenticate!
    if self.current_user.blank?
      session[:return_to] = request.url
      if Rails.env == 'development'
        redirect_to"/auth/developer"
      else
        redirect_to "/auth/aai"
      end
    else
      return true
    end
  end

end
