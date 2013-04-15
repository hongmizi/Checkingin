# coding: UTF-8
# for the member
class CheckinsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_the_project

  def index
    @projects = Project.all.select{ |p| p.users.include?(current_user)}

    params[:page] = 1 unless params[:page]
    @checkins = Checkin.where(user_id:current_user.id).paginate(page:params[:page])

  end
  def create
    authorize!(:read, @project)
    @checkin =  current_user.checkins.new(:project_id => @project.id)
    @project.checkins.each do |checkin|
      time = checkin.created_at
      now = Time.now
      if checkin.user == current_user and time.year == now.year and time.month == now.month and  time.day == now.day
        flash.alert = "你已经签到过了!"
        redirect_to project_path(@project)
        return
      end
    end

    if @checkin.save
      Notifier.check_in(current_user,@project, @checkin).deliver
      flash.notice = "恭喜你成功签到!" 
    else
      flash.alert = "签到失败!"
    end
    redirect_to project_path(@project)
  end
protected
  def find_the_project
    begin
      @project = Project.find(params[:project_id])
    rescue Exception
      @project = nil
    end
  end

end
