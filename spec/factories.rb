FactoryGirl.define do
  factory :user do
    email "user@test.com"
    password "123456789"
    password_confirmation "123456789"
  end
  factory :project do
    name "test"
    description "test description"
  end
end
