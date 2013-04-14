class CheckinDomain

  def get_user_checkins_on_month(time, user_id, project_id)
    @time = time
    @project = Project.find(project_id)
    @user = User.find(user_id)
    begin
      @checkins_on_month = {}
      for day in 1..Time.days_in_month(@time.month, @time.year)
        @checkins_on_month[day] = nil 
      end
      @user.checkins.where(:project_id => @project.id).each do |checkin|
        time = checkin.created_at
        if time.month == @time.month and time.year == @time.year
          @checkins_on_month[time.day] = checkin
        end
      end
    rescue Exception
    end
    return @checkins_on_month
  end

  def get_user_checkins_count_in_project(user_id, project_id)
    @project = Project.find(project_id)
    @user = User.find(user_id)
    @count = {}
        begin
          @count[:approved] =  @user.checkins.where(:state => "approved",:project_id => @project.id).count
        rescue Exception
          @count[:approved] = 0
        end

        begin
          @count[:declined] =  @user.checkins.where(:state => "declined",:project_id => @project.id).count
        rescue Exception
          @count[:declined] = 0 
        end

        begin
          @count[:pending] =   @user.checkins.where(:state => "pending", :project_id => @project.id).count
        rescue Exception
          @count[:pending] = 0
        end

        begin
          @count[:sum] =  @user.checkins.where(:project_id => @project.id).count
        rescue Exception
          @count[:sum] = 0 
        end

        return @count
  end

end