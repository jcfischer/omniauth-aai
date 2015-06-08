require 'rails/generators'
require "rails/generators/active_record"

module Aai
  class InstallGenerator < ActiveRecord::Generators::Base
    # include Rails::Generators::Migration

    desc "Generate Config Files / User / Session and Routes"

    class_option :persist, type: :boolean, default: true, desc: "Set to false if you don't want persistent User"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_initializer_file
      copy_file "omniauth.rb", "config/initializers/omniauth.rb"
    end

    def copy_session_controller_file
      if true
        template "session_controller.rb", "app/controllers/session_controller.rb"
        route("post '/auth/:provider/callback', :to => 'session#create', :as => 'auth_callback'")
        route("get '/auth/failure', :to => 'session#failure', :as => 'auth_failure'")
        route("get '/auth/logout',  :to => 'session#destroy', :as => 'logout'")
      end
    end

    def copy_user_file
      template "user.rb", "app/models/user.rb"
      migration_template "migration.rb", "db/migrate/aai_create_user.rb" if options[:persist]
    end

    # def self.next_migration_number(dirname)
    #   orm = Rails.configuration.generators.options[:rails][:orm]
    #   require "rails/generators/#{orm}"
    #   "#{orm.to_s.camelize}::Generators::Base".constantize.next_migration_number(dirname)
    # end
  end
end
