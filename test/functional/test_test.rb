require 'test_helper'

class TestTest < ActionMailer::TestCase
  test "good" do
    mail = Test.good
    assert_equal "Good", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "bad" do
    mail = Test.bad
    assert_equal "Bad", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
