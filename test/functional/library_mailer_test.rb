require 'test_helper'

class LibraryMailerTest < ActionMailer::TestCase

  context "send a nudge email to a user with a device on loan" do
    subject do
      user = FactoryGirl.build(:user, email: "a.user@library.abc", name: "Charles Coole")

      device = FactoryGirl.build(:device, model: "Palladio")
      copy = FactoryGirl.build(:copy, resource: device)
      loan = FactoryGirl.build(:loan, copy: copy, user: user)

      LibraryMailer.nudge_email(loan).deliver
    end

    should have_sent_email
           .to("a.user@library.abc")
           .with_subject("Reminder: Device \"Palladio\"")
           .with_body(/Hello Charles Coole/)
           .with_body(/Device "Palladio"/)
  end

end
