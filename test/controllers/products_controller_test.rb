require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get filter" do
    get products_filter_url
    assert_response :success
  end

end
