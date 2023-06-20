require 'rails_helper'

RSpec.describe "Post", type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { user.posts.build(content: "Lorem ipsum") }

  it "有効であること" do
    expect(post).to be_valid
  end

  it "user_idがない場合は無効となること" do
    post.user_id = nil
    expect(post).not_to be_valid
  end

  describe "content" do
    it "空なら無効であること" do
      post.content = "    "
      expect(post).not_to be_valid
    end
  end

  it "並び順が投稿の新しい順になっていること" do
    FactoryBot.send(:user_with_posts)
    expect(FactoryBot.create(:most_recent)).to eq Post.first
  end

  it "ユーザーが削除された場合、そのユーザーの投稿も削除されること" do
    post = FactoryBot.create(:most_recent)
    user = post.user
    expect { user.destroy }.to change(Post, :count).by -1
  end
end
