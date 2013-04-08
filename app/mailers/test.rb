class Test < ActionMailer::Base
  default from: "checkinginathmz@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test.good.subject
  #
  def good
    @greeting = "Hi"
    mail subject: "hello this is a test"
    mail to: "xyu.wang.0713@gmail.com"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.test.bad.subject
  #
  def bad
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
