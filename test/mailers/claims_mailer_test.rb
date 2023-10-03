require "test_helper"

class ClaimsMailerTest < ActionMailer::TestCase
  test "new_claim_email" do
    mail = ClaimsMailer.new_claim_email
    assert_equal "New claim email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
