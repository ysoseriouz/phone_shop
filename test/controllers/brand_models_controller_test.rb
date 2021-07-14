require "test_helper"

class BrandModelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get brand_models_index_url
    assert_response :success
  end
end
