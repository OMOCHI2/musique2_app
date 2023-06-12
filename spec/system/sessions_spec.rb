require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  describe "#new" do
    context "有効な値の場合" do
      let(:user) { FactoryBot.create(:user) }

      it "ログインユーザ用のページが表示されること" do
        visit login_path

        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"

        expect(page).not_to have_selector "a[href=\"#{login_path}\"]"
        expect(page).to have_selector "a[href=\"#{logout_path}\"]"
        expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
      end
    end

    context "無効な値の場合" do
      it "flashメッセージが表示されること" do
        visit login_path

        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        click_button "ログイン"

        expect(page).to have_selector "div.alert.alert-danger"

        visit root_path
        expect(page).not_to have_selector "div.alert.alert-danger"
      end
    end
  end
end
