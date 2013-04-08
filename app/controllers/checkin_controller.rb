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
end
