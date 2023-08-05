require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe "#new, #create" do
    let(:user) { FactoryBot.create(:user) }

    before do
      log_in user
      visit new_post_path
    end
    context "有効な場合" do
      it "記事を公開できること" do
        expect {
          fill_in "post_title", with: "Sample title"
          find(".trix-content").set("Sample content")
          click_on "公開する"
        }.to change(Post, :count).by 1

        post = Post.last
        expect(post.is_draft).to be_falsey
      end

      it "記事を下書きとして非公開で保存できること" do
        expect {
          fill_in "post_title", with: "Sample title"
          find(".trix-content").set("Sample content")
          click_on "下書き保存"
        }.to change(Post, :count).by 1

        post = Post.last
        expect(post.is_draft).to be_truthy
      end
    end

    context "無効な場合" do
      it "エラーメッセージ用の表示領域が描画されていること" do
        expect {
          fill_in "post_title", with: ""
          find(".trix-content").set("")
          click_on "公開する"
        }.not_to change(Post, :count)

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.field_with_errors"
      end
    end
  end

  describe "#edit, #update" do
    context "公開済み記事の場合" do
      it "有効な値のときは更新できること" do
      end

      it "無効な値のときは更新されず、エラーメッセージが表示されること" do
      end
    end

    context "下書き記事の場合" do
      it "有効な値のときは公開できること" do
      end

      it "有効な値のときは下書きを更新できること" do
      end

      it "無効な値のときは更新されず、エラーメッセージが表示されること" do
      end
    end
  end

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
  end
end
