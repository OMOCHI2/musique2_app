require 'rails_helper'

RSpec.describe "UsersSignup", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context "ユーザーの新規登録が出来るとき" do
    it "正しい情報入力により新規登録が出来ること" do
      visit root_path
      expect(page).to have_content "新規登録"
      visit signup_path
      fill_in "user[name]",                  with: @user.name
      fill_in "user[email]",                 with: @user.email
      fill_in "user[password]",              with: @user.password
      fill_in "user[password_confirmation]", with: @user.password_confirmation

      expect { find('input[name="commit"]').click }.to change { User.count }.by(1)
    end
  end

  context "ユーザーの新規登録が出来ないとき" do
    it "誤った情報入力では新規登録が出来ないこと" do
      visit root_path
      expect(page).to have_content "新規登録"
      visit signup_path
      fill_in "user[name]",                  with: ""
      fill_in "user[email]",                 with: ""
      fill_in "user[password]",              with: ""
      fill_in "user[password_confirmation]", with: ""

      expect { find('input[name="commit"]').click }.to change { User.count }.by(0)
    end
  end
end
