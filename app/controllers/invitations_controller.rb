# coding: UTF-8
class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  def create
    @project = Project.find(params[:project_id])
    authorize! :manage, @project
    token = (0...16).map{(65+rand(26)).chr}.join
    @user = User.find_by_email params[:user_email]
    # todo 查询是否已经邀请过了！是的话直接发送邮件
    @invitation = current_user.invitations.new(:invited_user_id => @user.id, :message => params[:message], :token => token, :project_id => @project.id)

    if @invitation.save
      Notifier.delay.invitation(@invitation) # TODO
      #Notifier.invite(@invitation).deliver
      flash.notice = "邀请成功,已发送邀请邮件!"
    else
      flash.alert = '邀请失败!'
    end

    redirect_to project_path params[:project_id] and return
  end

  def update
    invitation = Invite.find(params[:id])
    can?:read, invitation
    if current_user.id == invitation.invited_user_id and params[:token] == invitation.token
      if params[:state] == "approved" and InviteDomain.approved_invite invitation.id
        invitation.approve!
        flash.notice = "你成功加入项目！"
        redirect_to user_path current_user.id
          return
      elsif params[:state] == "declined"
        invitation.decline!
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
