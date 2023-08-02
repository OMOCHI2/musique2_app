RSpec.describe "Users", type: :system do

  describe "#new, #create" do
    context "有効な値の場合" do
      it "ユーザー登録時にアカウント画像が設定できること" do
        visit signup_path
        expect {
          fill_in "名前", with: "Valid Man"
          fill_in "メールアドレス", with: "user@valid.com"
          fill_in "パスワード", with: "foobar123"
          fill_in "確認用パスワード", with: "foobar123"
          attach_file "user[image]", "#{Rails.root}/spec/factories/kitten.jpg"
          click_button "登録する"
        }.to change(User, :count).by 1

        attached_user = User.last
        expect(attached_user.image).to be_attached
      end
    end

    context "無効な値の場合" do
      it "エラーメッセージ用の表示領域が描画されていること" do
        visit signup_path
        fill_in "名前", with: "Invalid Man"
        fill_in "メールアドレス", with: "user@invalid.com"
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

    it "管理者権限ユーザーなら削除リンクが表示されること" do
      log_in admin
      visit user_path(not_admin)

      expect(page).to have_link "違反ユーザーの削除"
    end

    it "管理者権限ユーザーでなければ削除リンクが表示されないこと" do
      log_in not_admin
      visit user_path(admin)

      expect(page).not_to have_link "違反ユーザーの削除"
    end
  end

  describe "#show" do
    context "follow_statsの検証" do
      it "フォローとフォロワーが正しく表示されること" do
        user = FactoryBot.send(:create_relationships)
        log_in user
        expect(page).to have_content "10 フォロー"
        expect(page).to have_content "10 フォロワー"

        visit user_path(user)
        expect(page).to have_content "10 フォロー"
        expect(page).to have_content "10 フォロワー"
      end
    end
  end
end
