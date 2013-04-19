# coding: UTF-8
class MembershipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_project_and_user
  def destroy
    if  Membership.where(project_id:@project.id, user_id:@user.id).first.destroy # todo should 对管理员和用户有不同的提示！ 更改测试 应该用id 删除某一个。
      redirect_to user_path current_user.id, notice:"成功！"
      return
    else
      redirect_to user_path current_user.id, notice:"失败!"
      return
    end
  end

  def show
  end

  private

  def get_project_and_user
    @project = Project.find(params[:project_id])
    unless params[:user_id]
      @user = current_user
    else
      @user = User.find(params[:user_id])
    end
    if can? :manage, @project
      return 
    elsif can? :read, @project
      @user = current_user
      return
    else
      redirect_to project_path @project.id, alert:"对不起，你无权访问这个项目!"
    end
  end
end
