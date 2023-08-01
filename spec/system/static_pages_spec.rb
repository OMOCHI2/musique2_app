require 'rails_helper'

RSpec.describe "StaticPages", type: :system do

  describe "site layouts" do
    before do
      visit root_path
    end

    it "ホーム画面が正しく表示されていること" do
      # ログインの有無に関わらずホーム画面にのみ表示されているべき要素
      expect(page).to have_selector "div.popular-posts"
    end

    describe "header" do
      it "アプリタイトルが表示されており遷移できること" do
        within "nav.navbar" do
          click_on "MUSIQUE"
          expect(current_path).to eq root_path
        end
      end

      it "ホームへのリンクが表示されており遷移できること" do
        within "nav.navbar" do
          click_on "ホーム"
          expect(current_path).to eq root_path
        end
      end

      it "ヘルプページへのリンクが表示されており遷移できること" do
        within "nav.navbar" do
          click_on "ヘルプ"
          expect(current_path).to eq help_path
        end
      end

      it "ログインページへのリンクが表示されており遷移できること" do
        within "nav.navbar" do
          click_on "ログイン"
          expect(current_path).to eq login_path
        end
      end
    end

    describe "footer" do
      it "アバウトページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "About"
          expect(current_path).to eq about_path
        end
      end

      it "お問い合わせページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "お問い合わせ"
          expect(current_path).to eq contact_path
        end
      end
    end
  end
end
