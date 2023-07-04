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

  describe "GET /posts #show" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:most_recent) }

    before do
      get post_path(post)
    end

    it "記事のタイトルが表示されていること" do
      expect(response.body).to include post.title
    end

    it "記事の本文が表示されていること" do
      expect(response.body).to include "<div class=\"trix-content\">"
    end
  end

  describe "GET /posts/id/edit #edit" do
    let(:user) { FactoryBot.create(:other_user) }

    before do
      @post = FactoryBot.create(:most_recent)
      log_in user
    end

    it "他のユーザーの投稿は編集画面へ遷移できず、ホーム画面にリダイレクトされること" do
      get edit_post_path(@post)
      expect(response).to redirect_to root_path
    end

    it "フラッシュメッセージが表示されていること" do
      get edit_post_path(@post)
      expect(flash).to be_any
    end
  end

  describe "DELETE /posts #destroy" do
    let(:user) { FactoryBot.create(:other_user) }

    before do
      @post = FactoryBot.create(:most_recent)
    end

    context "他のユーザーの投稿を削除した場合" do
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

      it "フラッシュメッセージが表示されていること" do
        delete post_path(@post)
        expect(flash).to be_any
      end
    end
  end
end
