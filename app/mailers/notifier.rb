# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  default from: "checkinginathmz@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.check_in.subject
  #
  def check_in member, project, line
    @project = project
    @member = member
    @line = line
    mail to: @project.owner.email, subject:"打卡通知"
  end
  def invite i
    @invite = i
    mail to: User.find(@invite.invited_user_id).email, subject:"项目邀请"
  end
   #handle_asynchronously :invite
   #handle_asynchronously :check_in
end
