require 'rails_helper'

RSpec.describe "Post", type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { user.posts.build(title:    "Sample title",
                                content:  "Sample content",
                                is_draft: false) }

  it "有効であること" do
    expect(post).to be_valid
  end

  it "user_idがない場合は無効となること" do
    post.user_id = nil
    expect(post).not_to be_valid
  end

  describe "title" do
    context "公開する場合" do
      it "空は無効であること" do
        post.title = "   "
        expect(post.save(context: :publicize)).not_to be_truthy
      end

      it "256文字以上は無効であること" do
        post.title = "a" * 256
        expect(post.save(context: :publicize)).not_to be_truthy
      end
    end

    context "下書き保存の場合" do
      it "空は有効であること" do
        post.title = "   "
        post.is_draft = true
        expect(post.save).to be_truthy
      end

      it "256文字以上は有効であること" do
        post.title = "a" * 256
        post.is_draft = true
        expect(post.save).to be_truthy
      end
    end
  end

  describe "content" do
    context "公開する場合" do
      it "空は無効であること" do
        post.content = "   "
        expect(post.save(context: :publicize)).not_to be_truthy
      end

      it "10001文字以上は無効であること" do
        post.content = "a" * 10001
        expect(post.save(context: :publicize)).not_to be_truthy
      end
    end

    context "下書き保存の場合" do
      it "空は無効であること" do
        post.content = "   "
        post.is_draft = true
        expect(post.save).to be_truthy
      end

      it "10001文字以上は無効であること" do
        post.content = "a" * 10001
        post.is_draft = true
        expect(post.save).to be_truthy
      end
    end
  end

  describe "is_draft" do
    it "デフォルトでは下書き機能はオフとなっていること" do
      expect(post.is_draft).to be_falsey
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
