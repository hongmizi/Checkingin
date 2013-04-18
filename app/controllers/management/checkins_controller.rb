# coding: UTF-8
class Management::CheckinsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_the_project
  before_filter :authorize_user

  # 用户的打卡情况
  def index
    @user = User.find(params[:member_id])
    @checkins = @project.checkins.where(:user_id => params[:member_id]).order("checkins.created_at asc")
    @year = params[:year]
    @year = Time.now.year if @year == nil
    @month = params[:month]
    @month = Time.now.month if @month == nil
    if @year == nil or @month == nil 
      @time = Time.now
    else
      @time = Time.new(@year,@month)
    end

    @time_next_month = @time
    @time_last_month = @time
    @time_next_month +=  24*3600 while @time_next_month.month == @time.month
    @time_last_month -=  24*3600 while @time_last_month.month == @time.month
    @time_last_month = Time.new(@time_last_month.year, @time_last_month.month)
    
    # find the earliest chinckin time in this project
    if @checkins.length != 0
      @time_earlist_checkin = @checkins.first.created_at
    else
      @time_earlist_checkin = Time.now
    end
    @checkins_on_month = CheckinDomain.new.get_user_checkins_on_month(@time,@user.id,@project.id)
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
    redirect_to project_path(@project)
  end
  
 
  protected
  def find_the_project
    @project = current_user.projects.find(params[:project_id])
  end
  
  def authorize_user
    find_the_project if @project.nil?

    authorize!(:manage, @project) 
  end
end
