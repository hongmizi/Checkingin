# coding: UTF-8
# for the member
class CheckinsController < ApplicationController
  before_filter :authenticate_user!

  def index
    begin
      @projects = Project.all.select{ |p| p.users.include?(current_user)}
    rescue Exception
      @projects = []
    end
    params[:page] = 1 unless params[:page]
    begin
      @checkins = Checkin.where(user_id:current_user.id).paginate(page:params[:page])
    rescue Exception
      @checkins = []
    end
  end
  def create
    find_the_project
   # debugger
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

  private
  def find_the_project
    @project = Project.find(params[:project_id])
  end

end
