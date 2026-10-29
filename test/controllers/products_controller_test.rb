require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: {  title: "Brand new title", description: @product.description, price: @product.price, image: fixture_file_upload("rails.png", "image/png") } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: {  title: @product. title, description: @product.description, price: @product.price, image: fixture_file_upload("rails.png", "image/png") } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  test "should not destroy product with line items" do
    assert_raises(ActiveRecord::RecordNotDestroyed) do
      delete product_url(products(:two)) # Assuming products(:two) has associated line items
    end

    assert Product.exists?(products(:two).id), "Product with line items should not be destroyed"
  end
end
