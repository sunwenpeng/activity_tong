require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get enroll" do
    get :enroll
    assert_response :success
  end

  test "should get modify_password" do
    get :modify_password_login_page
    assert_response :success
  end

end
