require "omniauth-aai/version"
require "omniauth-aai/has_current_user"
# require "action_controller/has_current_user"
require "omniauth"

module OmniAuth
  module Strategies
    autoload :Aai, 'omniauth/strategies/aai'
  end
end
