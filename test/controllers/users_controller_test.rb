require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should be get index" do
    get users_path
    assert_response :redirect
  end
end
