FactoryBot.define do
  factory :user, class: User do
    name                  { "Sample User" }
    email                 { "rails@example.com" }
    password              { "foobar123" }
    password_confirmation { "foobar123" }
    admin                 { true }
  end

  factory :other_user, class: User do
    name                  { "Other User" }
    email                 { "other@example.com" }
    password              { "foobar456" }
    password_confirmation { "foobar456" }
  end

  factory :continuous_users, class: User do
    sequence(:name)       { |n| "User #{n}" }
    sequence(:email)      { |n| "user-#{n}@example.com" }
    password              { "foobar789" }
    password_confirmation { "foobar789" }
  end
end
