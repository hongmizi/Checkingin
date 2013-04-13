# coding: UTF-8
class Management::CheckinsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_user
  before_filter :find_the_project

  # 用户的打卡情况
  def index
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
    @time_earlist_checkin = Time.now
    begin
      @checkins.each do |checkin|
        @time_earlist_check = checkin.created_at if @time_earlist_check > checkin.created_at
      end
    rescue Exception
    end
    # initilize the checkins on this month
    @days_num_months = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    @days_num_months[1] = 29 if Date.leap?(@time.year)
    @checkins_on_this_month = []
    for i in 1..@days_num_months[@time.month] 
      @checkins_on_this_month[i] = "nodata" 
    end
    @checkin_on_day = {}
    begin
      @user.checkins.where(:project_id => @project.id).each do |checkin|
        time = checkin.created_at
        if time.month == @time.month
          @checkins_on_this_month[time.day] = checkin.state
          @checkin_on_day[time.day] = checkin
        end
      end
    rescue Exception
    end

    @state_width = 200

    # 统计信息
    @emails = ""
    User.all.each do |user|
      if user != current_user
        select = "<option>"+ user.email + "</option>" 
        @emails += select
      end
    end
  end
  
  def update
    @checkin = @project.checkins.find(params[:id])
    
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
    authorize!(:manage, @project) 
  end
end
