$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'omniauth-aai'

require 'rack/test'
# require 'rspec'
# require 'omniauth'
# require 'omniauth/has_current_user'
# require 'omniauth-aai'
# require 'omniauth/version'
# require 'support/omniauth_macros'

RSpec.configure do |config|
    # config.include(OmniauthMacros)
    config.include Rack::Test::Methods
end

# OmniAuth.config.test_mode = true
