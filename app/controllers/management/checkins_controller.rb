# coding: UTF-8
class Management::CheckinsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_the_project
  before_filter :authorize_user

  # 用户的打卡情况
  def index
    @user = @project.users.find(params[:member_id])
    @checkins = @project.checkins.where(:user_id => params[:member_id]).order("checkins.created_at asc").page(params[:page]).per(30)

  end

  def update
    @checkin = @project.checkins.find(params[:id])
    state = params[:state]
    if @checkin.state != "pending"
      flash.alert = '你已经审批过了!'
      redirect_to project_path(@project)
      return 
    end
    if state == 'approved'
      @checkin.approve
    elsif state == 'declined'
      @checkin.decline
    end
    if @checkin.save
      flash.notice = '审批成功!'
    else
      flash.alert = '审批失败!'
    end
    redirect_to project_checkins_path(@project, member_id: @checkin.user.id)
  end
  
 
  protected
  def load_the_project
    @project = current_user.projects.find(params[:project_id])
  end
  
  def authorize_user
    load_the_project if @project.nil?

    authorize!(:manage, @project) 
  end
end
