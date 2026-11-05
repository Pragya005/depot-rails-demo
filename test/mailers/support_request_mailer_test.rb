require "test_helper"

class SupportRequestMailerTest < ActionMailer::TestCase
  test "respond" do
    mail = SupportRequestMailer.respond(support_requests(:one))
    assert_equal "Re: Problem with my order", mail.subject
    assert_equal [ "customer@example.com" ], mail.to
    assert_equal [ "support@example.com" ], mail.from
  end
end
