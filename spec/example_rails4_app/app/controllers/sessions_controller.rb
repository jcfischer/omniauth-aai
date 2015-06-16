class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: [:new, :create], if: Rails.env.development?
  before_filter :authenticate!, only: :new

  def new
    redirect_to(session.delete( :return_to ) || root_path)
  end

  def create
    self.current_user = User.update_or_create_with_omniauth_aai(auth_hash)

    flash[:notice] = "Login successful"

    redirect_to(session.delete( :return_to ) || root_path)
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

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
