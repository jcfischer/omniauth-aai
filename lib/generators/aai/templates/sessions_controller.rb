class SessionsController < ApplicationController

  before_filter :authenticate!, only: :new
  skip_before_filter :verify_authenticity_token, only: [:new, :create], if: Rails.env.development?

  def new
  end

  def create
<% if options[:persist] -%>
    self.current_user = User.update_or_create_with_omniauth_aai(auth_hash)
<% else -%>
    user = User.new
    user.uid = auth_hash[:uid]
    user.aai = auth_hash
    self.current_user = user
<% end -%>

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
