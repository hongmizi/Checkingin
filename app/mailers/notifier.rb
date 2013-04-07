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
    User.all.each { |user| @admin = user if user.projects.include?@project }
    mail to: @admin.email
  end
end
