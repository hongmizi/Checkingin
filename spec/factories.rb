FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email_#{n}@test.com"}
    password "123456789"
    password_confirmation "123456789"
    nickname "test"
  end

  factory :project do
    name "test"
    description "test description"
  end

  factory :membership do
  end
  factory :checkin do
  end

end
