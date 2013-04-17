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
  end
end
