require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
    login_as users(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:pragprog).id }
    end

    follow_redirect!
    assert_select "h2", "Your Cart"
    assert_select "td", "Pragmatic Programmers"
    # assert_redirected_to line_item_url(LineItem.last)
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to store_index_url
  end

  test "should change line_item quantity via turbo_stream" do
    patch line_item_url(@line_item), params: { amount: 1 }, as: :turbo_stream

    assert_response :success
    assert_equal 2, @line_item.reload.quantity
    assert_select 'turbo-stream[action="replace"][target="cart"]'
  end

  test "decreasing quantity to one does not remove the line_item" do
    @line_item.update!(quantity: 2)

    patch line_item_url(@line_item), params: { amount: -1 }, as: :turbo_stream

    assert_response :success
    assert_equal 1, @line_item.reload.quantity
  end

  test "decreasing quantity below one removes the line_item" do
    assert_difference("LineItem.count", -1) do
      patch line_item_url(@line_item), params: { amount: -1 }, as: :turbo_stream
    end

    assert_response :success
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to store_index_url
  end

  test "should create line_item via turbo_stream" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:pragprog).id }, as: :turbo_stream
    end

    assert_response :success
    assert_match /<tr class="line-item-highlight">/, @response.body
  end

  test "adding a line item resets the store page view counter via turbo_stream" do
    5.times { get store_index_url }
    assert_select "#store_counter", "5"

    post line_items_url, params: { product_id: products(:pragprog).id }, as: :turbo_stream

    assert_response :success
    assert_select 'turbo-stream[action="replace"][target="store_counter"]' do
      assert_select "span#store_counter", "0"
    end
  end

  test "should add unique line items to the cart" do
    assert_difference("LineItem.count", 1) do
      post line_items_url, params: { product_id: products(:pragprog).id }
    end
  end

  test "should increment quantity for duplicate line items" do
    post line_items_url, params: { product_id: products(:two).id }
    assert_no_difference("LineItem.count") do
      post line_items_url, params: { product_id: products(:two).id }
    end
    cart = Cart.find(session[:cart_id])
    assert_equal 2, cart.line_items.first.quantity
  end
end
