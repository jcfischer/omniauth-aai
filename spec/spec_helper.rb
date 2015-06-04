require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth/version'
require 'omniauth-aai'
require 'support/omniauth_macros'

RSpec.configure do |config|
    config.include(OmniauthMacros)

    config.include Rack::Test::Methods
    config.color = true
end

# OmniAuth.config.test_mode = true
