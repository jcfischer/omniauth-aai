class SessionController < ApplicationController

  def create
    auth_hash[:uid] = auth_hash[:info][:email] if Rails.env.development?

    if User.superclass == ActiveRecord::Base
      self.current_user = User.find_or_create_by_uid( auth_hash[:uid] )
    else
      self.current_user = User.new
      self.current_user.uid = auth_hash[:uid]
    end

    self.current_user.aai = auth_hash

    flash[:notice] = "Login successful"
    redirect_to(session[:return_to] || root_path)
  end

  def failure
    flash[:error] = "Login failed"
    redirect_to(root_path)
  end

  def destroy
    self.current_user = nil
    flash[:notice] = "Logout successful"
    redirect_to(root_path)
  end


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
  
end