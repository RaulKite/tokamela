# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do
  factory :user do
    sequence (:name)  { |n| "Test User #{n}" }
    sequence (:email) { |n| "example#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
  end
end
