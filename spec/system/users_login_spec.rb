require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do
  before do
    @user = FactoryBot.create(:user)
    visit login_path
  end

  context "ログインが出来るとき" do
    it "作成済みのユーザー情報と合致すればログインが出来ること" do
      fill_in 'session[email]', with: @user.email
      fill_in 'session[password]', with: @user.password
      find('input[name="commit"]').click
      expect(current_path).to eq root_path
      expect(page).to have_content "ログインしました"
    end
  end

end
