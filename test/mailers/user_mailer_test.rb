require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    mail = UserMailer.welcome_email(users(:one))
    assert_equal "Welcome to Depot", mail.subject
    assert_equal [ "one@example.com" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
  end
end
