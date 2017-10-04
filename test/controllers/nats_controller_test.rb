require 'test_helper'

class NatsControllerTest < ActionDispatch::IntegrationTest
   test "should be get index" do
     get nats_path
     assert_response :redirect
   end
end
