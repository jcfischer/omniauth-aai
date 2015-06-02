require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth/version'
require 'omniauth-shibboleth'
require 'omniauth-aai'

RSpec.configure do |config|
    config.include Rack::Test::Methods
    config.color = true
end
