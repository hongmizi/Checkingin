# coding: UTF-8
# for the member
class CheckinsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_the_project, :only => [:create]

  def index
    @projects = current_user.joined_projects
    params[:page] = 1 unless params[:page]
    @checkins = Checkin.where(user_id:current_user.id).paginate(page:params[:page])
  end

  def create
    authorize!(:read, @project)
    @checkin =  current_user.checkins.new(:project_id => @project.id)

    if params[:date].present?
      @checkin.created_at = Time.strptime params[:date], "%m/%d/%Y"
    end

    @project.checkins.each do |checkin|
      last_time = checkin.created_at
      time = Time.now
      if checkin.user == current_user and time.year == last_time.year and time.month == last_time.month and  time.day == last_time.day
       return redirect_to project_path(@project), alert:"你已经签到过了!"
      end
    end

    if @checkin.save
      # TODO: break the test
      #Notifier.delay.check_in(current_user, @project, @checkin)
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
