FactoryBot.define do
  factory :stock do
    user { association :user, email: "stock@example.com" }
    post { association :post_by_other }
  end
end
