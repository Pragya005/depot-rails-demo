require "application_system_test_case"

class StoreTest < ApplicationSystemTestCase
  test "add to cart reveals cart and empty cart hides it" do
    visit store_index_url
    assert_no_selector "#cart"
    click_on "Add to Cart", match: :first
    assert_selector "#cart"
    click_on "Empty Cart"
    assert_no_selector "#cart"
  end
end
