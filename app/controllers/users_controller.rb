require 'ruby-debug'

class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @projects = current_user.projects
  end

end
