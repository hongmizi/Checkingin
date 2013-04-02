class UserHomeController < ApplicationController
  def index
    check_signed_in
      @projects = current_user.projects
  end

  def check_signed_in
    if user_signed_in?
    else
      flash[:alert] = "You need to sign in first."
      redirect_to root_path
    end
  end

  def new_project
    check_signed_in
    @project=current_user.projects.new
  end
end
