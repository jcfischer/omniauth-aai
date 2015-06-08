require 'active_support/concern'

module Omniauth
  module HasCurrentUser
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def has_current_user
        helper_method :current_user
        include Omniauth::HasCurrentUser::LocalInstanceMethods
      end
    end


    module LocalInstanceMethods
      @user = nil

      def current_user
        return nil unless @user.present? || session[:current_user].present?
        @user = @user || User.unmarshal( session[:current_user] )
        @user
      end

      # Set the current user
      def current_user=(user)
        @user = user
        session[:current_user] = @user.marshal unless @user.nil?
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
        return true if self.current_user.present? && self.current_user.uid.present?
        return false
      end
    end

  end

  begin
    ActionController::Base.extend HasCurrentUser
  rescue NameError => e
    puts "ActionController undefined"
  end

end
