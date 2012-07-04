# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-aai/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'omniauth-shibboleth'

  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.8'
  gem.add_development_dependency 'guard-rspec'

  gem.authors       = ["Claudio Beffa"]
  gem.email         = ["claudio@beffa.ch"]
  gem.description   = %q{OmniAuth Shibboleth strategies for SWITCHaai}
  gem.summary       = %q{OmniAuth Shibboleth strategies for SWITCHaai}
  gem.homepage      = "https://github.com/switch-ch/omniauth-aai"

  gem.files         = `find . -not \\( -regex ".*\\.git.*" -o -regex "\\./pkg.*" -o -regex "\\./spec.*" \\)`.split("\n").map{ |f| f.gsub(/^.\//, '') }
  gem.test_files    = `find spec/*`.split("\n")
  gem.name          = "omniauth-aai"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Aai::VERSION


end
