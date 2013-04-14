# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['RAILS_ENV'] ||= 'development'
# Initialize the rails application
Checkingin::Application.initialize!
Checkingin::Application.configure do
  config.action_mailer.delivery_method = :smtp
end
ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "domain.of.sender.net",
    :authentication => "plain",
    :user_name => "checkinginathmz",
    :password => "hongmizi",
    :enable_starttls_auto => true,
    :authentication  => :login
}
