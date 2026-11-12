require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal [ "pragyajoney2005@gmail.com" ], mail.to
    assert_equal [ "pragyavarshney.web@gmail.com" ], mail.from
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal [ "pragyajoney2005@gmail.com" ], mail.to
    assert_equal [ "pragyavarshney.web@gmail.com" ], mail.from
  end

  test "should send email when ship date changes" do
    order = orders(:one)
    order.update!(ship_date: Date.new(2026, 11, 20))

    mail = OrderMailer.ship_date_updated(order)

    assert_equal "Pragmatic Store Order Ship Date Updated", mail.subject
    assert_equal [ order.email ], mail.to
    assert_equal [ "pragyavarshney.web@gmail.com" ], mail.from

    assert_match "2026-11-20", mail.body.encoded
  end
end
