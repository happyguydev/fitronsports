require 'test_helper'

class PoliciesControllerTest < ActionDispatch::IntegrationTest
  test "should get terms" do
    get policies_terms_url
    assert_response :success
  end

  test "should get privacy" do
    get policies_privacy_url
    assert_response :success
  end

end
