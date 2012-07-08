require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get protected" do
    get :protected
    assert_response :success
  end

  test "should get other_protected" do
    get :other_protected
    assert_response :success
  end

end
