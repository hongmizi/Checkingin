require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  test "check_in" do
    mail = Notifier.check_in
    assert_equal "Check in", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
