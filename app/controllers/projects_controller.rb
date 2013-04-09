class ProjectsController < ApplicationController
  def index
  end

  def show
    @project = Project.find(params[:id])
    @new_member = ""
    if current_user.projects.include?(@project)
      @admin = true
    else
      @admin = false
    end
    # 统计数量
    @approve = {}
    @decline = {}
    @pending = {}
    @sum = {}
    @project.users.each do |user|
      @approve[user] = 0
      @decline[user] = 0
      @sum[user] = 0
      @pending[user] = 0
    end

    @project.checkins.each do |checkin |
      if checkin.state == "approved"
        @approve[checkin.user] += 1
      end
      if checkin.state == "declined"
        @decline[checkin.user] += 1
      end
      if checkin.state == "pending"
        @pending[checkin.user] += 1
      end
      @sum[checkin.user] += 1

    end

  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(params[:project])

    if @project.save
      redirect_to user_path(current_user.id)
    else
      render "new"
    end
  end
  
  def edit
  end

  def update
  end

  def destroy
  end

  def create_member
    #get => push   身份验证
    id = params[:project_id]
    @project = Project.find(id)
    if not @project
      flash.alert = "can't find Project Plase try again!!!"
      redirect_to project_path(id)
      return 
    end
    user_email= params[:new_member]
    @user = User.find_by_email(user_email)
    if not @user
      flash.alert = "can't find user!!!"
      redirect_to project_path(id)
      return 
    end
    if @project.users.include?(@user)
      flash.alert = "already have this user!"
      redirect_to project_path(id)
      return
    end
     a= Membership.new :user_id => @user.id, :project_id => @project.id
    if a.save
      flash.notice = 'success'
    else
      flash.notice = 'added failed'
    end
      redirect_to project_path(id)
      return 
  end
end
