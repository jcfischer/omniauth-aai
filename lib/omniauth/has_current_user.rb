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
      @_omniauth_user = nil

      def current_user
        return nil unless @_omniauth_user.present? || session[:current_user].present?
        @_omniauth_user = @_omniauth_user || User.unmarshal(session[:current_user] )
        @_omniauth_user
      end

      def current_user=(user)
        @_omniauth_user = user
        session[:current_user] = @_omniauth_user.marshal unless @_omniauth_user.nil?
      end

      def authenticate!
        return if authenticated?
        session[:return_to] = request.url
        if Rails.env.development? or Rails.env.test?
          redirect_to '/auth/developer'
        else
          redirect_to '/auth/aai'
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
