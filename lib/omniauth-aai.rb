require "omniauth-aai/version"
require "omniauth"
require "omniauth/has_current_user"

module OmniAuth
  module Strategies
    autoload :Aai, 'omniauth/strategies/aai'
  end
end
