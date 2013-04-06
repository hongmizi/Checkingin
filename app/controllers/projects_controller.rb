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
  def check_in
    @project = Project.find(params[:id])
    @project.checkins.each do |checkin |

      time = checkin.created_at
      now = Time.now
      if checkin.user == current.user and time.year == now.year and time.month == now.month and  time.day == now.day
        flash.alert = "you already checked in !!!"
        redirect_to project_path(params[:id])
      end
    end
      a = Checkin.new(:user_id => current_user.id,:project_id => @project.id, :state => "pending")
      if a.save
        flash.alert = "success added check in!"
      else
        flash.alert = "failed added check in!!"
      end
    redirect_to project_path(params[:id])
    return 
  end
end
