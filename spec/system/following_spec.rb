require 'rails_helper'

RSpec.describe "Following", type: :system do
  before do
    @user = FactoryBot.send(:create_relationships)
    log_in @user
  end

  describe "following" do
    it "フォロー数とフォローしているユーザーへのリンクが表示されていること" do
      visit following_user_path(@user)
      expect(@user.following).not_to be_empty
      expect(page).to have_content "10 フォロー"
      @user.following.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end

  describe "followers" do
    it "フォロワー数とフォローされているユーザーへのリンクが表示されていること" do
      visit followers_user_path(@user)
      expect(@user.followers).not_to be_empty
      expect(page).to have_content "10 フォロワー"
      @user.followers.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end
end
