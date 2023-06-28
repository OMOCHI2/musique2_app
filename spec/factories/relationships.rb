FactoryBot.define do
  factory :follower, class: Relationship do
    follower_id { 1 }
    followed_id { 1 }
  end

  factory :following, class: Relationship do
    follower_id { 1 }
    followed_id { 1 }
  end
end

def create_relationships
  continuous_users = FactoryBot.create_list(:continuous_users, 10)

  FactoryBot.create(:user) do |user|
    continuous_users.each do |other|
      FactoryBot.create(:follower, follower_id: other.id, followed_id: user.id)
      FactoryBot.create(:following, follower_id: user.id, followed_id: other.id)
    end
    user
  end
end
