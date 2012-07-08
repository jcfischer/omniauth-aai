class SessionController < ApplicationController

  def create
    self.current_user = User.set(auth_hash)
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
  end

  def failure
    # whatever happens if auth fails
  end

  def destroy
    # not implemented 
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
