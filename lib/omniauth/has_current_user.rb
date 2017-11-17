require 'active_support/concern'

module Omniauth
  module HasCurrentUser
    extend ActiveSupport::Concern

    included do
      helper_method :current_user
    end

    module ClassMethods
      def has_current_user
        include Omniauth::HasCurrentUser::InstanceMethods
      end
    end

    module InstanceMethods
      @user = nil

      def current_user
        return nil unless @user.present? || session[:current_user].present?
        @user = @user || User.unmarshal( session[:current_user] )
        @user
      end

      def current_user=(user)
        @user = user
        session[:current_user] = @user.marshal unless @user.nil?
      end

      def authenticate!
        return if authenticated?
        session[:return_to] = request.url
        if Rails.env.production?
          redirect_to "/auth/aai"
        else
          redirect_to "/auth/developer"
        end
      end

      def authenticated?
        return true if self.current_user.present? && self.current_user.uid.present?
        return false
      end

    end
  end
end

begin
  ActionController::Base.send :include, Omniauth::HasCurrentUser
rescue NameError => e
  puts "ActionController undefined"
end
