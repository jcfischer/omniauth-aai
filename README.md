# OmniAuth AAI strategy

OmniAuth Shibboleth AAI strategy is an OmniAuth strategy for authenticating through SWITCHaai.

- OmniAuth: https://github.com/intridea/omniauth/wiki
- Shibboleth: https://wiki.shibboleth.net/
- SWITCHaai: http://www.switch.ch/aai/index.html

Most functionallity is based on https://github.com/toyokazu/omniauth-shibboleth

## Getting Started

### Installation

Install as a gem via Gemfile or with

    % gem install omniauth-aai


### Generator

    rails generate aai:install

This will generate some basic authenthication objects for rails:

* config/omniauth.rb
* app/controller/session_controller.rb
* app/models/user.rb
* db/migrate/create_users_adapt_and_copy_to_migration.rb

You'll need to configure at least the 'db/migrate/create_users_adapt_and_copy_to_migration.rb' file. Just run 'rails g migration createUsersTable' copy the content of 'create_users_adapt_and_copy_to_migration.rb' and delete it.

You can run it with '--persist false' if you don't want to persist the user to the local db.

If you want more than just the uid persisted, change the 'user.rb' and override the 'aai=' method to do so and the migration to add the columns.

```ruby
    def aai=(aai)
      self.email = auth_hash[:info][:email]
      @aai = aai
    end
```

### Additional Shibboleth attributes

By default, you will get all the standard SWITCHaai values, or you can configure it via options:

```ruby
    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :aai,{
        :uid_field => :'persistent-id',
        :fields => [:name, :email, :swiss_ep_uid],
        :extra_fields => [:'Shib-Authentication-Instant']# See lib/omniauth/strategies/aai.rb for full list.
      }
```

Fields are provided in the Env as request.env["omniauth.auth"]["info"]["name"] and extra_fields attributes are provided as ['extra']['raw_info']['Shib-Authentication-Instant'].


### How to authenticate users

Setup your web server to request a valid shibboleth session for the Location/Directory /auth/aai. In your application, send users to '/auth/aai' to have them sign in via the WAYF and your organizations' IdP.  After successful login the user gets redirected to '/auth/aai/callback', from where your application should take over again.

SWITCHaai strategy only checks the existence of Shib-Session-ID or Shib-Application-ID, not anything else. See devise or the genrator for further libraries to authenticate user.


### Development Mode

In development/local mode or in cases where you don't have a SWITCHaai Service Provider (SP) installed and configured, you can use the following mock (with default SWITCHaai values):

```ruby
    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      if Rails.env.development?
        provider :developer, {
          :uid_field => :'persistent-id',
          :fields => OmniAuth::Strategies::Aai::DEFAULT_FIELDS,
          :extra_fields => OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
        }
      end
    end
````

### Debug Mode

When you deploy a new application, you may want to confirm the assumed attributes are correctly provided by SWITCHaai SP. OmniAuth SWITCHaai strategy provides a confirmation option :debug. If you set :debug to true, you can see the environment variables provided at the /auth/aai/callback uri.

```ruby
    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :aai, { :debug => true }
    end
```

### Current User

If you want to use the build in User object and the 'current_user' functionality, you can use the magic call 'has_current_user'

```ruby
    class ApplicationController < ActionController::Base
      protect_from_forgery
      has_current_user
    end
```


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
