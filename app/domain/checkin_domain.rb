class CheckinDomain

  def self.user_checkins_on_month_in_project(user, time, project)
      checkins_on_month = {}
      #for day in 1..Time.days_in_month(@time.month, @time.year)
      #  @checkins_on_month[day] = nil 
      #end

      user.checkins.where(:project_id => project.id).each do |checkin|
        created_at = checkin.created_at
        if created_at.month == time.month and created_at.year == time.year
          checkins_on_month[time.day] = checkin.state
        end
      end

      checkins_on_month
  end

  def self.state_of_checkins checkins_on_month
    pending = 0
    declined = 0
    approved = 0
    checkins_on_month.each do |k, v|
      if v == "approved"
        approved += 1
      elsif v == "declined"
        declined += 1
      elsif v == "pending" 
        pending += 1
      end
    end

    state = {pending: pending, declined: declined, approved: approved}
  end

  def get_user_checkins_count_in_project(user_id, project_id)
    @project = Project.find(project_id)
    @user = User.find(user_id)
    @count = {}
    @count[:approved] =  @user.checkins.where(:state => "approved",:project_id => @project.id).count
    @count[:declined] =  @user.checkins.where(:state => "declined",:project_id => @project.id).count
    @count[:pending] =   @user.checkins.where(:state => "pending", :project_id => @project.id).count
    @count[:sum] =  @user.checkins.where(:project_id => @project.id).count
    return @count
  end

end
