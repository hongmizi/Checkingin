# coding: UTF-8
class MembershipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project_and_user
  def destroy
    if  Membership.where(project_id:@project.id, user_id:@user.id).first.destroy # todo should use destory
      flash.notice = "退出项目成功！"
      redirect_to user_path current_user.id
      return
    else
      flash.alert = "退出项目失败！"
      redirect_to user_path current_user.id
      return
    end
  end
end
def show
end
private

def get_project_and_user
  @project = Project.find(params[:project_id])
  unless @project
    flash.alert = "找不到项目！"
    redirect_to root_path 
    return
  end
  unless params[:user_id]
    @user = current_user
  else
    @user = User.find(params[:user_id])
  end
  unless @user
    flash.alert = "找不到用户"
    redirect_to project_path @project.id
    return
  end
  if not @project.users.include? @user and not can? :manage, @project
    flash.alert = "对不起，你无权访问这个项目!"
    redirect_to project_path @project.id
  end
end
