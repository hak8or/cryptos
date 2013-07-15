require 'test_helper'

class StaticpagesControllerTest < ActionController::TestCase
  test "should get homepage" do
    get :homepage
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
