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
#    mail :subject => "打卡通知"
    mail to: @project.owner.email
  end
  def invite i
    @invite = i
 #   mail :subject => "项目邀请"
    mail to: User.find(@invite.invited_user_id).email
  end
   #handle_asynchronously :invite
   #handle_asynchronously :check_in
end
