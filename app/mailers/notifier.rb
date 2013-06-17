# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  default from: "checkinginathmz@gmail.com"

  def check_in member, project, checkin
    @project = project
    @member = member
    @checkin = checkin
    mail to: @project.owner.email, subject: "打卡通知"
  end

  def invite i
    @invite = i
    mail to: User.find(@invite.invited_user_id).email, subject:"项目邀请"
  end
end
