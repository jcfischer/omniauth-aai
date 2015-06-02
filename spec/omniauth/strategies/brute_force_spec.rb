require 'spec_helper'
#require 'capybara/rspec'

describe "include gem" do
  #needs sqllit in gems, but this conflicts with jruby
  it "should not raise any exceptions" do
   FileUtils.cp_r("spec/example_rails4_app", "spec/test_app_with_active_record")
   #`cd spec/test_app_with_active_record; bundle install --gemfile=Gemfile`
   `cd spec/test_app_with_active_record; bundle exec  --gemfile=Gemfile rails generate aai:install`
   `cd spec/test_app_with_active_record; bundle exec  --gemfile=Gemfile rake db:migrate`
   FileUtils.rm_r("spec/test_app_with_active_record")
  end

  it "should not raise any exceptions if not persist gem with app" do
    FileUtils.cp_r("spec/example_rails4_app", "spec/test_app_no_persist")
    `cd spec/test_app_no_persist; bundle exec rails generate aai:install --persist false`
    FileUtils.rm_r("spec/test_app_no_persist")
  end
end

#describe "test app ar" do
#  before(:all) do
#    FileUtils.cp_r("spec/example_rails_app", "spec/test_app")
#    `cd spec/test_app; bundle exec rails generate aai:install`
#    `cd spec/test_app; bundle exec rake db:migrate`
#    require './spec/test_app/config/environment'
#    Capybara.app = TestApp1::Application
#  end
#  after(:all) do
#    FileUtils.rm_r("spec/test_app")
#  end
#
#  describe "check the app", :type => :request do
#    it "index page" do
#      visit('/welcome/index')
#      page.should have_content('Welcome#index')
#    end
#  end
#end

#describe "test app not ar" do
#  before(:all) do
#    FileUtils.cp_r("spec/example_rails_app", "spec/test_app_no_persist")
#    `cd spec/test_app_no_persist; bundle exec rails generate aai:install --persist false`
#    FileUtils.cp("spec/example_rails_app/change_application_controller.rb", "spec/test_app_no_persist/app/controllers/application_controller.rb")
#    require './spec/test_app_no_persist/config/environment'
#    Capybara.app = TestApp1::Application
#  end
#  after(:all) do
#    FileUtils.rm_r("spec/test_app_no_persist")
#  end
#
#  describe "check the app", :type => :request do
#    it "index page" do
#      visit('/welcome/index')
#      page.should have_content('Welcome#index')
#    end
#  end
#
#end
#
#
