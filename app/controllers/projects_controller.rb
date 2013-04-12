# coding: UTF-8
class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @project = Project.find(params[:id])
    authorize!(:read,@project)
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
    
    user = params[:user]
    @user = User.find(user) if user
    if @user == nil and can? :manage, @project
      @user = @project.users.first
    end
    @user = current_user unless @user
    
    # find the earliest chinckin time in this project
    @time_earlist_checkin = Time.now
    begin
      @project.checkins.where(:user_id => @user).each do |checkin|
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
    can? :manage, @project
    @emails = ""
    User.all.each do |user|
      if user != current_user
        select = "<option>"+ user.email + "</option>" 
        @emails += select
      end
    end
    @number_of_approved_for_user = {}
    @number_of_declined_for_user = {}
    @number_of_pending_for_user = {}
    @number_of_checkin_sum_for_user = {}
    begin
      @project.users.each do |member|
        begin
          @number_of_approved_for_user[member.id] =  member.checkins.where(:state => "approved",:project => @project).count 
        rescue Exception
          @number_of_approved_for_user[member.id] = 0 
        end

        begin
          @number_of_declined_for_user[member.id] =  member.checkins.where(:state => "declined",:project => @project).count 
        rescue Exception
          @number_of_declined_for_user[member.id] = 0 
        end

        begin
          @number_of_pending_for_user[member.id] =   member.checkins.where(:state => "pending", :project => @project).count 
        rescue Exception
          @number_of_pending_for_user[member.id] = 0
        end
        
        begin
          @number_of_checkin_sum_for_user[member.id] =  member.checkins.where(:project_id => @project.id).count
        rescue Exception
          @number_of_checkin_sum_for_user[member.id] = 0 
        end

      end
    rescue Exception
    end
      end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(params[:project])
    if @project.save
      flash.notice = "创建成功！"
      redirect_to user_path(current_user.id)
      return
    else
      flash.alert = "创建失败！"
      render "new"
    end
  end

  def edit
  end

  def destroy
  end

  def update
    id = params[:id]
    @project = Project.find(id)
    if not @project
      flash.alert = "不能找到此项目,请重试!"
      redirect_to project_path(id)
      return 
    end
    authorize! :manage, @project
    if @project.owner != current_user
      flash.alert = "你不是此项目的管理员!"
      redirect_to project_path(id)
      return
    end
    user_email= params[:new_member]
    @user = User.find_by_email(user_email)
    if not @user
      flash.alert = "不能找到相应用户,请重新输入!"
      redirect_to project_path(id)
      return
    end
    if @project.users.include?(@user)
      flash.alert = "此用户已经在项目中了.."
      redirect_to project_path(id)
      return
    end
    if @project.owner == @user 
      flash.alert = "你不能添加自己为项目成员..."
      redirect_to project_path(id)
      return
    end
    if Membership.create!(:user_id => @user.id, :project_id => @project.id)
      flash.notice = "成功添加用户!"
      redirect_to project_path(id)
      return 
    else
      flash.alert = "添加用户失败!"
      redirect_to project_path(id)
      return
    end
  end
end
