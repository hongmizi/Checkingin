class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
   render :file => Rails.root.join("public", "404.html"), :status => 404
  end
end
