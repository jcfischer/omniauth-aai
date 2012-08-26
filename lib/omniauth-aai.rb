require "omniauth-aai/version"
require "omniauth"
#require "generators/aai/install_generator"

module OmniAuth
  module Strategies
    autoload :Aai, 'omniauth/strategies/aai'
  end
end
