class HomeController < ApplicationController
  def index
    @projects_num = Project.count
    @users_num = User.count
  end
end
