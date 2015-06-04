class SessionController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: :create, if: Rails.env.development?

  def create

    self.current_user = User.update_or_create_with_omniauth_aai(auth_hash)

    # #Add  whatever fields you want to save
    # self.current_user = User.where(uid: auth_hash[:uid]).first_or_initialize
    # # self.current_user = User.find_or_create_by_uid( auth_hash[:uid] )
    # #Auth Hash is not persistent
    # self.current_user.raw_data = auth_hash
    # self.current_user.save


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

  # protected

  # def auth_hash
  #   request.env['omniauth.auth']
  # end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  # def user_params
  #   user_params = auth_hash
  #   user_params ? user_params
  #     .permit(
  #       :uid
  #     ) : {}
  # end


end
