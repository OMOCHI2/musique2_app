FactoryBot.define do
  factory :user do
    name                  { "Sample User" }
    email                 { "rails@example.com" }
    password              { "foobar123" }
    password_confirmation { "foobar123" }
  end
end
