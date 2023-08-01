require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  let!(:daw) { FactoryBot.create(:daw) }

  describe "site layouts" do
    before do
      visit root_path
    end

    describe "home" do
      it "ホーム画面が正しく表示されていること" do
        # ログインの有無に関わらずホーム画面にのみ表示されているべき要素
        expect(page).to have_selector "div.popular-posts"
      end

      it "未ログイン状態で表示されるカルーセル上に、新規登録ボタンが表示されており遷移できること" do
        within "section.hero" do
          click_on "新規登録する"
          expect(current_path).to eq signup_path
        end
      end

      it "カテゴリー名からカテゴリー検索結果ページに遷移できること" do
        within "aside" do
          click_on "DAW"
          expect(current_url).to eq "http://www.example.com/categories?name=DAW"
        end
      end
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
      it "アプリタイトルが表示されており遷移できること" do
        within "footer" do
          click_on "MUSIQUE"
          expect(current_path).to eq root_path
        end
      end

      it "Aboutページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "About"
          expect(current_path).to eq about_path
        end
      end

      it "利用規約ページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "利用規約"
          expect(current_path).to eq terms_path
        end
      end

      it "プライバシーポリシーページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "プライバシーポリシー"
          expect(current_path).to eq privacy_path
        end
      end

      it "ヘルプページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "ヘルプ"
          expect(current_path).to eq help_path
        end
      end

      it "お問い合わせページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "お問い合わせ"
          expect(current_path).to eq contact_path
        end
      end

      it "会社情報ページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "会社情報"
          expect(current_path).to eq company_path
        end
      end

      it "採用情報ページへのリンクが表示されており遷移できること" do
        within "footer" do
          click_on "採用情報"
          expect(current_path).to eq jobs_path
        end
      end
    end
  end
end
