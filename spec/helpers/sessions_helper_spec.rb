require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }

  describe "current_user" do
    before do
      remember(user)
    end

    it "sessionが空のとき、current_userが正しく返ってくること" do
      expect(current_user).to eq user
      expect(logged_in?).to be_truthy
    end

    it "remember_digestが違うとき、current_userがnilを返すこと" do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to eq nil
    end
  end
end
