# coding: UTF-8
class Invitation::InvitesController < ApplicationController
  before_filter :authenticate_user!
  def create
    @project = Project.find(params[:project_id])
    authorize! :manage, @project
    token = (0...16).map{(65+rand(26)).chr}.join
    @user = User.find_by_email params[:user_email]
    # todo 查询是否已经邀请过了！是的话直接发送邮件
    @invite = current_user.invites.new(:invited_user_id => @user.id, :message => params[:message], :token => token, :project_id => @project.id)

    if @invite.save
      Notifier.invite(@invite).deliver
      redirect_to project_path params[:project_id], :notice => "邀请成功,已发送邀请邮件!"
      return
    else
      flash.
      redirect_to project_path params[:project_id], alert:'邀请失败!'
    end
  end

  def update
    invite = Invite.find(params[:id])
  #  debugger
  #  puts "--------- 1"
  #  puts current_user.id
  #  puts invite.invited_user_id
  #  puts current_user.id == invite.invited_user_id
  #  puts "--------- 2 "
  #  puts invite.token
  #  puts params[:token] 
  #  puts params[:token] == invite.token
  #  puts "-----------------------------"
    if current_user.id == invite.invited_user_id and params[:token] == invite.token
      if params[:state] == "approved" and InviteDomain.approved_invite invite 
        invite.approve!
        flash.notice = "你成功加入项目！"
        redirect_to user_path current_user.id
          return
      elsif params[:state] == "declined"
        invite.decline!
        flash.alert = "你已拒绝参加此项目!"
        redirect_to user_path current_user.id
        return 
      else
        flash.alert = "参加项目失败！"
        redirect_to user_path current_user.id        
        return
      end
    else
      flash.alert = "链接已失效!"
      redirect_to root_path
      return
    end
  end
end
