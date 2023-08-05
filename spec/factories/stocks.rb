FactoryBot.define do
  factory :stock do
    user factory: :user
    post { association :post_by_other }
  end
end
