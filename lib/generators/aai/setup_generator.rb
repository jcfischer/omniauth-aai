module Aai
  class SetupGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path("../templates", __FILE__)

    desc "Generate Config Files / User / Session and Routes"

    class_option :persist, type: :boolean, default: true, desc: "Set to false if you don't want persistent User"

    # def self.source_root
    #   @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    # end

    def copy_initializer_file
      copy_file "omniauth.rb", "config/initializers/omniauth.rb"
    end

    def copy_sessions_controller_file
      if true
        template "sessions_controller.rb", "app/controllers/sessions_controller.rb"
        inject_into_class "app/controllers/application_controller.rb", ApplicationController, "  has_current_user\n"
        route("post '/auth/:provider/callback', to: 'sessions#create', as: :auth_callback")
        route("get '/auth/failure', to: 'sessions#failure', as: :auth_failure")
        route("get '/auth/logout',  to: 'sessions#destroy', as: :logout")
        route("get '/auth/login',  to: 'sessions#new', as: :login")
      end
    end

    def copy_user_file
      template "user.rb", "app/models/user.rb"
      migration_template "migration.rb", "db/migrate/create_aai_user.rb" if options[:persist]
      # rake "db:migrate"
    end

    def self.next_migration_number(path)
      unless @prev_migration_nr
        @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      else
        @prev_migration_nr += 1
      end
      @prev_migration_nr.to_s
    end
  end
end
