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

    rails generate aai:setup

This will generate some basic authenthication objects for rails:

* config/initializers/omniauth.rb
* app/controller/sessions_controller.rb
* app/models/user.rb
* db/migrate/<timestamp>_create_aai_user.rb

You can run it with '--persist false' if you don't want to persist the user to the local db.

You'll need to run 'rake db:migrate' afterwards to create the user table.

### Additional Shibboleth attributes

By default, you will get all the core SWITCHaai values, or you can configure it via options:

```ruby
    # config/initializer/omniauth.rb
    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :aai,{
        :uid_field => :'persistent-id',
        :extra_fields => [:'Shib-Authentication-Instant']# See lib/omniauth/strategies/aai.rb for full list.
      }
```

Fields are provided in the Env as request.env["omniauth.auth"]["info"]["name"] (or auth_hash.info.unique_id) and extra_fields attributes are provided as request.env["omniauth.auth"]['extra']['raw_info']['Shib-Authentication-Instant'].


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
          uid_field: :'persistent-id',
          fields: [:name, :email, :persistent_id, :unique_id],
          extra_fields: OmniAuth::Strategies::Aai::DEFAULT_EXTRA_FIELDS
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

In order for you to use the build in User object and the 'current_user' functionality, the has_current_user method has been added to the ApplicationController during the setup.

```ruby
    class ApplicationController < ActionController::Base
      has_current_user
      protect_from_forgery
    end
```
