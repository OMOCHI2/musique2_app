RSpec.describe "Users", type: :system do

  describe "#create" do
    context "無効な値の場合" do
      it "エラーメッセージ用の表示領域が描画されていること" do
        visit signup_path
        fill_in "名前", with: "Invalid Man"
        fill_in "メールアドレス", with: "user@invlid.com"
        fill_in "パスワード", with: "foobar"
        fill_in "確認用パスワード", with: "barbaz"
        click_button "登録する"

        expect(page).to have_selector "div#error_explanation"
        expect(page).to have_selector "div.field_with_errors"
      end
    end
  end

  describe "#index" do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:not_admin) { FactoryBot.create(:other_user) }

    it "adminユーザならdeleteリンクが表示されること" do
      log_in admin
      visit users_path

      expect(page).to have_link "ユーザーの削除"
    end

    it "adminユーザでなければdeleteリンクが表示されないこと" do
      log_in not_admin
      visit users_path

      expect(page).not_to have_link "ユーザーの削除"
    end
  end
end
