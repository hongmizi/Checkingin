class ProjectsController < ApplicationController
  def index
  end

  def show
    @project = Project.find(params[:id])
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

end
