require "application_system_test_case"
class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  test "check dynamic fields" do
    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"
    assert has_no_field? "Routing Number"
    assert has_no_field? "Account Number"
    assert has_no_field? "Credit Card Number"
    assert has_no_field? "Expiration Date"
    assert has_no_field? "PO #"
    select "Check", from: "Pay Type"
    assert has_field? "Routing Number"
    assert has_field? "Account Number"
    assert has_no_field? "Credit Card Number"
    assert has_no_field? "Expiration Date"
    assert has_no_field? "PO #"
    select "Credit Card", from: "Pay Type"
    assert has_no_field? "Routing Number"
    assert has_no_field? "Account Number"
    assert has_field? "Credit Card Number"
    assert has_field? "Expiration Date"
    assert has_no_field? "PO #"
    select "Purchase Order", from: "Pay Type"
    assert has_no_field? "Routing Number"
    assert has_no_field? "Account Number"
    assert has_no_field? "Credit Card Number"
    assert has_no_field? "Expiration Date"
    assert has_field? "PO #"
  end

  test "check order and delivery" do
    LineItem.delete_all
    Order.delete_all
    visit store_index_url
    click_on "Add to Cart", match: :first
    click_on "Checkout"
    fill_in "Name", with: "Drashti"
    fill_in "Address", with: "123 Main Street"
    fill_in "Email", with: "pragyajoney2005@gmail.com"
    select "Check", from: "Pay Type"
    fill_in "Routing Number", with: "123456"
    fill_in "Account Number", with: "987654"
    click_button "Place Order"
    assert_text "Thank you for your order"
    perform_enqueued_jobs
    perform_enqueued_jobs
    assert_performed_jobs 2
    orders = Order.all
    assert_equal 1, orders.size
    order = orders.first
    assert_equal "Drashti", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "pragyajoney2005@gmail.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size
    mail = ActionMailer::Base.deliveries.last
    assert_equal [ "pragyajoney2005@gmail.com" ], mail.to
    assert_equal "Pragya Varshney <pragyavarshney.web@gmail.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
