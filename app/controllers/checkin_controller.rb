class CheckinController < ApplicationController
  def create
  @project = Project.find(params[:project_id])
    @project.checkins.each do |checkin |

      time = checkin.created_at
      now = Time.now
      if checkin.user == current_user and time.year == now.year and time.month == now.month and  time.day == now.day
        flash.alert = "you already checked in !!!"
        redirect_to project_path(params[:project_id])
        return 
      end
    end
     c = Checkin.new(:user_id => current_user.id,:project_id => @project.id, :state => "pending")
     if c.save
       Notifier.check_in(current_user,@project,c).deliver
       flash.alert = "success added check in!"
     else
        flash.alert = "failed added check in!!"
     end
    redirect_to project_path(params[:project_id])
    return 

  end

  def update
    checkin = params[:id]
    state = params[:state]
    project_id = params[:project_id]
    project = Project.find(project_id)
    #判断是否是项目管理人
    @admin = project.owner
    if @admin.blank? or current_user.blank? or  @admin.id != current_user.id
      flash.alert = 'you is not admin !'
      redirect_to project_path(project_id)
      return 
    end
    c= project.checkins.find(checkin)
    if c.state != "pending"
      flash.alert = 'you already declined/approved !'
      redirect_to project_path(project_id)
      return 
    end
    if state == 'approved'
      c.approve
    elsif state == 'declined'
      c.decline
    end
    if c.save
      flash.notice = 'success'
    else
      flash.alert = 'failed!'
    end
    redirect_to project_path(project_id)
  end
end
