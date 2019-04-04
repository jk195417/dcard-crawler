require 'test_helper'

class Admin::PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get statistics" do
    get admin_pages_statistics_url
    assert_response :success
  end

end
