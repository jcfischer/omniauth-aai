require "omniauth-aai/version"
require "omniauth"
require "action_controller/has_current_user"

module OmniAuth
  module Strategies
    autoload :Aai, 'omniauth/strategies/aai'
  end
end
