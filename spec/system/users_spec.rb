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
end
