$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "omniauth-aai/version"

Gem::Specification.new do |gem|
  gem.name          = "omniauth-aai"
  gem.version       = OmniAuth::Aai::VERSION
  gem.authors       = ["Christian Rohrer"]
  gem.email         = ["christian.rohrer@switch.ch"]
  gem.homepage      = "https://github.com/switch-ch/omniauth-aai"
  gem.description   = %q{OmniAuth strategy for SWITCHaai}
  gem.summary       = %q{OmniAuth strategy for SWITCHaai, the shibboleth implementation used for the Swiss HEI federation.}
  gem.license       = "MIT"


  gem.add_dependency 'omniauth-shibboleth', '~> 1.2'
  # gem.add_dependency 'omniauth'

  gem.add_development_dependency 'rack-test', '~> 0.6'
  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'guard-rspec', '~> 4.5'
  gem.add_development_dependency 'rails', '~> 4.2'
  # gem.add_development_dependency 'capybara'
  #gem.add_development_dependency 'sqlite3'


  gem.files         = `find . -not \\( -regex ".*\\.git.*" -o -regex "\\./pkg.*" -o -regex "\\./spec.*" \\)`.split("\n").map{ |f| f.gsub(/^.\//, '') }
  gem.test_files    = `find spec/*`.split("\n")
  gem.require_paths = ["lib"]


end
