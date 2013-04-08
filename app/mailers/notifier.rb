# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  default from: "checkinginathmz@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.check_in.subject
  #
  def check_in member, project,line
    @project = project
    @member = member
    @line = line
    mail subject: "打卡通知"
    mail to: @project.owner.email
  end
end
