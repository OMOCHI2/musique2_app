FactoryBot.define do
  factory :user, class: User do
    name                  { "Sample User" }
    email                 { "user@examples.com" }
    password              { "foobar123" }
    password_confirmation { "foobar123" }
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }
  end

  factory :other_user, class: User do
    name                  { "Other User" }
    email                 { "other@example.com" }
    password              { "foobar456" }
    password_confirmation { "foobar456" }
    activated             { true }
    activated_at          { Time.zone.now }
  end

  factory :hanako, class: User do
    name                  { "Rails Hanako" }
    email                 { "hanako@example.com" }
    password              { "foobar456" }
    password_confirmation { "foobar456" }
    activated             { true }
    activated_at          { Time.zone.now }
  end

  factory :taro, class: User do
    name                  { "Ruby Taro" }
    email                 { "taro@example.com" }
    password              { "foobar456" }
    password_confirmation { "foobar456" }
    activated             { true }
    activated_at          { Time.zone.now }
  end

  factory :continuous_users, class: User do
    sequence(:name)       { |n| "User #{n}" }
    sequence(:email)      { |n| "user-#{n}@example.com" }
    password              { "foobar789" }
    password_confirmation { "foobar789" }
    activated             { true }
    activated_at          { Time.zone.now }
  end

  factory :not_activated_user, class: User do
    name                  { "Not Activated" }
    email                 { "invalid@example.com" }
    password              { "barbaz123" }
    password_confirmation { "barbaz123" }
  end
end
