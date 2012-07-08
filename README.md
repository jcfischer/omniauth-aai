# OmniAuth AAI strategy

OmniAuth Shibboleth AAI strategy is an OmniAuth strategy for authenticating through SWITCHaai. 

- OmniAuth: https://github.com/intridea/omniauth/wiki
- Shibboleth: https://wiki.shibboleth.net/
- SWITCHaai: http://www.switch.ch/aai/index.html

Most functionallity is borrwoed from https://github.com/toyokazu/omniauth-shibboleth

## Getting Started

### Installation

Install as a gem via Gemfile or with

    % gem install omniauth-aai

### Setup SWITCHaai Strategy

To use Shibboleth SWITCHaai strategy as a middleware in your rails application, add the following file to your rails application initializer directory. (There will be a generator soon)


    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :aai, {}
    end

You will get by default all the standard SWITCHaai values, or you can configure it via options:

    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :aai,{
        :uid_field => :'persistent-id',
        :fields => [:name, :email, :swiss_ep_uid],
        :extra_fields => [:'Shib-Authentication-Instant']# See lib/omniauth/strategies/aai.rb for full list.
      }

Fields are provided in the Env as request.env["omniauth.auth"]["info"]["name"] and extra_fields attributes are provided as ['extra']['raw_info']['Shib-Authentication-Instant'].

### How to authenticate users

In your application, simply direct users to '/auth/aai' to have them sign in via your organizations's AAI SP and IdP. '/auth/aai' url simply redirect users to '/auth/aai/callback', so thus you must protect '/auth/aai/callback' by SWITCHaai SP.

SWITCHaai strategy just checks the existence of Shib-Session-ID or Shib-Application-ID.

### Development Mode

In development / local mode you can use the following mock (with default SWITCHaai values):

    # config/initializer/omniauth.rb
    use OmniAuth::Builder do
      provider :developer, {
        :uid_field => :'persistent-id',
        :fields => OmniAuth::Strategies::Aai::DEFAULT_FIELDS,
        :extra_fields => OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
      } if Rails.env == 'development'
    end

### Debug Mode

When you deploy a new application, you may want to confirm the assumed attributes are correctly provided by SWITCHaai SP. OmniAuth SWITCHaai strategy provides a confirmation option :debug. If you set :debug true, you can see the environment variables provided at the /auth/aai/callback uri.

    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :aai, { :debug => true }
    end

## License (MIT License)

Copyright (C) SWITCH, Zurich, original copyright (omniauth-shibboleth) 2011 by Toyokazu Akiyama.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.