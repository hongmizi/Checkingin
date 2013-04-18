# coding: UTF-8
class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
  end
  def profile
    # @projects = Project.all.select { |p| p.users.include? current_user }
    @projects = ProjectDomain.get_user_joined_project current_user
    @nickname = "" 
  end
  
  def show
    @projects = current_user.projects
    @join_projects =[]
    Project.all.each do |project|
      if project != nil and project.users.include?(current_user)
        @join_projects << project
      end
    end
  end
  
  def update
    if params[:nickname] and params[:nickname] != ""
      current_user.nickname = params[:nickname]
      if current_user.save
        flash.notice = "更改名字成功！"
        redirect_to "/profile/"
      else
        flash.alet = "更改名字失败！"
        redirect_to "/profile"
      end
    else
      flash.alert = "请输入名字！"
      redirect_to "/profile/"
    end
  end
end
