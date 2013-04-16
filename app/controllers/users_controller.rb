class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index

  end
  def show
    @projects = current_user.projects
    @join_projects =[]
    Project.all.each do |project|
      if project != nil and project.users.include?(current_user)
        @join_projects << project
      end
    end
  end
end
