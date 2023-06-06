require 'rails_helper'

RSpec.describe "StaticPages", type: :system do

  describe "site layouts" do
    before do
      visit root_path
    end

    it "ホーム画面が正しく表示されていること" do
      expect(page).to have_content "Welcome to the Musique"
    end

    describe "header" do
      it "アプリタイトルが表示されており遷移できること" do
        within "header" do
          click_on "Musique"
          expect(current_path).to eq root_path
        end
      end

      it "ホームへのリンクが表示されており遷移できること" do
        within "header" do
          click_on "Home"
          expect(current_path).to eq root_path
        end
      end

      it "ヘルプページへのリンクが表示されており遷移できること" do
        within "header" do
          click_on "Help"
          expect(current_path).to eq help_path
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

      it "コンタクトページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "Contact"
          expect(current_path).to eq contact_path
        end
      end
    end
  end
end
