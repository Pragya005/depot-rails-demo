require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest
  def setup
    login_as users(:one)
     Product.find_each do |product|
      File.open(Rails.root.join("test/fixtures/files/rails.png")) do |image|
        product.images.attach(
          io: image,
          filename: "rails.png",
          content_type: "image/png"
        )
      end
    end
  end
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 3
    assert_select "h1", "Your Pragmatic Catalog"
    assert_select "div", /\$[,\d]+\.\d\d/ # verifies the price format is correct
  end
end
