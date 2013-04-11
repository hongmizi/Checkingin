# coding: UTF-8
class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @project = current_user.projects.find(params[:id])
    authorize!(:read,@project)
    
    begin
      @number_of_approved =  current_user.checkins.where(:state => "approved",:project => @project).count 
    rescue Exception
      @number_of_approved = 0
    end
    
    begin
      @number_of_declined =  current_user.checkins.where(:state => "declined",:project => @project).count 
    rescue Exception
      @number_of_declined = 0
    end
    
    begin
      @number_of_pending =   current_user.checkins.where(:state => "pending", :project => @project).count 
    rescue Exception
      @number_of_pending = 0
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
    if @project.owner == current_user
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
