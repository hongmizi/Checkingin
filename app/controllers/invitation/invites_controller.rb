# coding: UTF-8
class InvitesController < ApplicationController
  before_filter :authenticate_user!
  def create
    debugger
    token = (0...16).map{(65+rand(26)).chr}.join
    @user = User.find_by_email params[:user_email]
    unless @user 
      flash.alert = "您邀请的用户不存在！"
      redirect_to project params[:project_id]
    end
    @invite = current_user.invites.new(:invited_user_id => @user.id, :message => params[:message], :token => token)
   
    if @invite.save
      Notifier.invite @invite
      flash.notice = "邀请成功,已发送邀请邮件!"
      redirect_to project params[:project_id]
    else
      flash.alert = '邀请失败!'
      redirect_to project params[:project_id]
    end
  end
  def update
    invite = Invite.find(params[:id])
    if current_user.id == invite.invited_user_id and params[:token] == invite.token
      if params[:state] == "approved"
        invite.approve!
        flash.notice "你成功加入项目！"
        redirect_to user current_user.id
      elsif params[:state] == "declined"
        invite.decline!
        flash.alert = "你已拒绝参加此项目!"
        redirect_to user current_user.id
      end

      
    end
end
end

