require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
    login_as users(:one)
  end
  test "require item in cart" do
      get new_order_url
      assert_redirected_to store_index_path
      assert_equal flash[:notice], "Your cart is empty"
  end

  test "should get new" do
      post line_items_url, params: { product_id: products(:pragprog).id }
      get new_order_url
      assert_response :success
  end

  test "should create order" do
    assert_difference("Order.count") do
      post orders_url(locale: I18n.locale), params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }
    end
    assert_redirected_to store_index_url(locale: I18n.locale)
  end

  test "should send email when ship date changes" do
    order = orders(:one)

    assert_enqueued_emails 1 do
      patch order_url(order), params: {
        order: {
          ship_date: Date.new(2026, 11, 20)
        }
      }
    end
  end

  test "should generate order links with current locale" do
    get orders_url(locale: :es)
    assert_response :success
  end
end
