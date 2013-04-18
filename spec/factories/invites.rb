# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    user_id 1
    project_id 1
    invited_user_id 1
    message "MyString"
    state "pending"
    token "123456789"
  end
end
