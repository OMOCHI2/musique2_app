require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe "Users#show" do
    before do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      @user = Post.first.user
    end

    it "30件表示されていること" do
      visit user_path(@user)

      posts_wrapper =
        within "ol.posts" do
          find_all("li")
        end
      expect(posts_wrapper.size).to eq 30
    end

    it "ページネーションのタグが表示されていること" do
      visit user_path(@user)
      expect(page).to have_selector "div.pagination"
    end

    it "Postの本文がページ内に表示されていること" do
      visit user_path @user
      @user.posts.paginate(page: 1).each do |post|
        expect(page).to have_content post.content
      end
    end
  end
end
