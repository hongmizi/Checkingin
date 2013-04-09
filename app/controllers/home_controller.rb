class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to user_path(current_user.id)
      return
    end
    @projects_num, @users_num = 0, 0
    @projects_num = Project.count
    @users_num = User.count
  end
end
