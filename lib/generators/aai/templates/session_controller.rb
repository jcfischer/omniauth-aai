class SessionController < ApplicationController

  def create

  <% if options[:persist] %>
    #Add  whatever fields you want to save
    self.current_user = User.find_or_create_by_uid( auth_hash[:uid] )
    #Auth Hash is not persistent
    self.current_user.aai = auth_hash
  <% else %>
    user = User.new
    user.uid = auth_hash[:uid]
    user.aai = auth_hash
    self.current_user = user
  <% end %>

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


  protected

  def auth_hash
    request.env['omniauth.auth']
  end
  
end