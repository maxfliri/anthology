class LibraryMailer < ActionMailer::Base
  default from: "from@example.com"
  helper :application

  def nudge_email(loan)
    @loan = loan
    mail(to: loan.user.email, subject: "Reminder: #{loan.copy.resource_type} \"#{loan.copy.resource.title}\"")
  end
end
