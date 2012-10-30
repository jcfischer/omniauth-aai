module HasCurrentUser
  def has_current_user
    helper_method :current_user
    include InstanceMethods
  end
  module InstanceMethods
    @user = nil

    def current_user() 
      if @user.present? || session[:current_user].present?
        @user || User.unmarshal( session[:current_user] ) 
      else
        return nil
      end
    end

    # Set the current user
    def current_user=(user) 
      @user = user
      session[:current_user] = @user.marshal if @user.present?
    end
    
    # Authenticate User
    def authenticate!
      return if authenticated?
      session[:return_to] = request.url
      if Rails.env.development?
        redirect_to "/auth/developer"
      else
        redirect_to "/auth/aai"
      end
    end
    
    # User authenticated?
    def authenticated?
      return true if self.current_user
      return false
    end
  end
end

begin
  ActionController::Base.extend HasCurrentUser
rescue NameError => e
  puts "ActionController undefined"
end
