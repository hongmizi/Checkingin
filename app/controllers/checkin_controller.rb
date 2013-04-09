# coding: UTF-8
class CheckinController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @project.checkins.each do |checkin |
      time = checkin.created_at
      now = Time.now
      if checkin.user == current_user and time.year == now.year and time.month == now.month and  time.day == now.day
        flash.alert = "你已经签到过了!"
        redirect_to project_path(params[:project_id])
        return
      end
    end

     checkin =  Checkin.new(:user_id => current_user.id,:project_id => @project.id)
     if checkin.save
       Notifier.check_in(current_user,@project,checkin).deliver
       flash.notice = "恭喜你成功签到!" 
     else
       flash.alert = "签到失败!"
     end
    redirect_to project_path(params[:project_id])
    return 
  end

  def update
    id         = params[:id]
    state      = params[:state]
    project_id = params[:project_id]
    
    project = Project.find(project_id)
    #判断是否是项目管理人
    @admin = project.owner
    if @admin.blank? or current_user.blank? or  @admin.id != current_user.id
      flash.alert = '对不起,你不是项目管理人!'
      redirect_to project_path(project_id)
      return 
    end

    checkin = project.checkins.find(id)
    if checkin.state != "pending"
      flash.alert = '你已经审批过了!'
      redirect_to project_path(project_id)
      return 
    end
    if state == 'approved'
      checkin.approve
    elsif state == 'declined'
      checkin.decline
    end
    if checkin.save
      flash.notice = '审批成功!'
    else
      flash.alert = '审批失败!'
    end
    redirect_to project_path(project_id)
  end
end
