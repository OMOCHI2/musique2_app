FactoryBot.define do
  factory :orange, class: Post do
    title      { "Sample Post"}
    content    { "I just ate an orange!" }
    created_at { 10.minutes.ago }
  end

  factory :most_recent, class: Post do
    title      { "Sample Post"}
    content    { "Writing a short test" }
    created_at { Time.zone.now }
    user       { association :user, email: "ecent@example.com" }
  end

  factory :post_by_user, class: Post do
    title      { "Sample Post"}
    content    { "Posted by User" }
    created_at { Time.zone.now }
    user       factory: :user
  end

  factory :post_by_taro, class: Post do
    title      { "Sample Post"}
    content    { "Posted by Taro" }
    created_at { Time.zone.now }
    user       factory: :taro
  end

  factory :post_by_hanako, class: Post do
    title      { "Sample Post"}
    content    { "Posted by Hanako" }
    created_at { Time.zone.now }
    user       factory: :hanako
  end
end

def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:orange, posts_count, user: user)
  end
end
