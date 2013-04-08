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
      if checkin.state == "approve"
        @approve[checkin.user] += 1
      end
      if checkin.state == "decline"
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

  def change_state
    checkin = params[:checkin]
    state = params[:state]
    project_id = params[:id]
    project = Project.find(project_id)
    #判断是否是项目管理人
    
    User.all.each { |user| @admin = user if  user.projects.include?(project)}
    #puts @admin.id
    #puts params[:user_id]
    #puts @admin.id.to_s != params[:user_id]
    if @admin.blank? or current_user.blank? or  @admin.id != current_user.id
      flash.alert = 'you is not admin !'
      redirect_to project_path(id)
      return 
    end
    c= project.checkins.find(checkin)
    c.state = state
    if c.save
      flash.notice = 'success'
    else
      flash.alert = 'failed!'
    end
    redirect_to project_path(project_id)
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

  def check_in
    @project = Project.find(params[:id])
    @project.checkins.each do |checkin |

      time = checkin.created_at
      now = Time.now
      if checkin.user == current_user and time.year == now.year and time.month == now.month and  time.day == now.day
        flash.alert = "you already checked in !!!"
        redirect_to project_path(params[:id])
        return 
      end
    end
     a = Checkin.new(:user_id => current_user.id,:project_id => @project.id, :state => "pending")
     if a.save
       #mail
       Notifier.check_in(current_user,@project,a).deliver
       flash.alert = "success added check in!"
     else
        flash.alert = "failed added check in!!"
     end
    redirect_to project_path(params[:id])
    return 
  end
end
