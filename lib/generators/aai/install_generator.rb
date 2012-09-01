require 'rails/generators'
require 'rails/generators/migration'

module Aai
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc "Generate Config Files / User / Session and Routes"

    class_option :persist, :type => :boolean, :default => true, :desc => "Set to false if you don't want persistent User"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_initializer_file
      copy_file "omniauth.rb", "config/initializers/omniauth.rb"
    end

    def copy_session_controller_file
      if true
        copy_file "session_controller.rb", "app/controllers/session_controller.rb"
        route("match '/auth/:provider/callback', :to => 'session#create', :as => 'auth_callback'")
        route("match '/auth/failure', :to => 'session#failure', :as => 'auth_failure'")
        route("match '/auth/logout',  :to => 'session#destroy', :as => 'logout'")
      end
    end

    def copy_user_file
      template "user.rb", "app/models/user.rb"
      migration_template "migration.rb", "db/migrate/create_users_table.rb" if options[:persist]
    end

  end
end