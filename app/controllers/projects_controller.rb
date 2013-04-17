# coding: UTF-8
class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
    @project = Project.find(params[:id])
    authorize!(:read,@project)
  end

  def new
    @project = current_user.projects.new
  end

  def create
    @project = current_user.projects.new(params[:project])
    if @project.save
      redirect_to user_path(current_user.id), :notice => "创建成功！"
      return
    else
      render "new", :alert => "创建失败！"
    end
  end

  def edit
  end

  def destroy
  end

  def update
    id = params[:id]
    @project = Project.find(id)
    authorize! :manage, @project

    user_email= params[:new_member]
    @user = User.find_by_email(user_email)
    if @project.users.include?(@user)
      redirect_to project_path(id), alert:"此用户已经在项目中了.."
      return
    end
    if @project.owner == @user 
      redirect_to project_path(id), alert:"你不能添加自己为项目成员..."
      return
    end
    if Membership.create!(:user_id => @user.id, :project_id => @project.id)
      redirect_to project_path(id),notice:"成功添加用户!"
      return 
    else
      redirect_to project_path(id), alert:"添加用户失败!"
      return
    end
  end
end
