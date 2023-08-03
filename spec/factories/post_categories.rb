FactoryBot.define do
  factory :post_category, class: PostCategory do
    post     factory: :orange
    category factory: :daw
  end

  factory :category_page_test, class: PostCategory do
    post     factory: :most_recent
    category factory: :daw
  end
end
