require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /index" do
    let(:user)           { FactoryBot.create(:user)}
    let(:category)       { FactoryBot.create(:daw) }
    let!(:post_category) { FactoryBot.create(:category_page_test) }

    it "カテゴリー名を指定していない時は記事一覧ページにリダイレクトすること" do
      get categories_path
      expect(response).to redirect_to posts_path
      expect(response).to have_http_status(302)
    end

    context "カテゴリー名を指定した場合" do
      it "正しく遷移できること" do
        get categories_path, params: { name: "DAW" }
        expect(response).to have_http_status :success
      end

      it "カテゴリーに紐付いた投稿が表示されること" do
        post = Post.find(post_category.post_id)
        get categories_path, params: { name: "DAW" }
        expect(response.body).to include post.title
      end

      it "存在しないカテゴリー名の時は記事一覧ページにリダイレクトすること" do
        get categories_path, params: { name: "none" }
        expect(response).to redirect_to posts_path
        expect(response).to have_http_status(302)
      end
    end
  end
end
