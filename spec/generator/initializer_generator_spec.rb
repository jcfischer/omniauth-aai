require 'spec_helper'

describe "initializer generator" do
  context 'clean rails app' do
    before do
      @rails_root = "../rails_app"
      @init_file_path = File.expand_path("#{@rails_root}/config/initializers/omniauth.rb", __FILE__)
      @rails_root_path = File.expand_path("#{@rails_root}", __FILE__)
      File.delete(@init_file_path) if File.exists? @init_file_path
      @output = []
    end

    it 'create an initializer' do
      @output << `cd #{@rails_root_path}`
      @output << `bundle install`
      @output << `bundle exec rails generate shibboleth:initializer`
      File.exists?( @init_file_path ).should( be_true, @output)
    end
  end
end