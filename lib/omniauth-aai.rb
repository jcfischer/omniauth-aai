require "omniauth-aai/version"
require "omniauth"
require "omniauth/has_current_user"
# require "action_controller/has_current_user"

module OmniAuth
  module Strategies
    autoload :Aai, 'omniauth/strategies/aai'
  end
end
