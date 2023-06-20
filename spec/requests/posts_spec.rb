require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "POST /posts #create" do
    context "未ログインの場合" do
      it "登録されないこと" do
        expect {
          post posts_path, params: { post: { content: 'Lorem ipsum' } }
        }.not_to change(Post, :count)
      end

      it "ログインページにリダイレクトされること" do
        post posts_path, params: { post: { content: 'Lorem ipsum' } }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE /posts #destroy" do
    let(:user) { FactoryBot.create(:other_user) }

    before do
      @post = FactoryBot.create(:most_recent)
    end

    context "他のユーザの投稿を削除した場合" do
      before do
        log_in user
      end

      it "削除されないこと" do
        expect { delete post_path(@post) }.not_to change(Post, :count)
      end
    end

    context "未ログインの場合" do
      it "削除されないこと" do
        expect { delete post_path(@post) }.not_to change(Post, :count)
      end

      it "ログインページにリダイレクトされること" do
        delete post_path(@post)
        expect(response).to redirect_to login_path
      end
    end
  end
end
