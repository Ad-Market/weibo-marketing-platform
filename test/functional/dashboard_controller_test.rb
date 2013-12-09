require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get showdata" do
    get :showdata
    assert_response :success
  end

end
