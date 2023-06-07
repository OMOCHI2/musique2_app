require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  describe "ユーザーの新規登録" do
    context "新規登録がうまくいくとき" do
      it "内容に問題がないこと" do
        expect(@user).to be_valid
      end
    end

    context "新規登録がうまくいかないとき" do
      it "名前が空のときは登録出来ないこと" do
        @user.name = "     "
        expect(@user).not_to be_valid
      end

      it "メールアドレスが空のときは登録出来ないこと" do
        @user.email = "     "
        expect(@user).not_to be_valid
      end

      it "名前が31文字以上の場合は登録出来ないこと" do
        @user.name = "a" * 31
        expect(@user).not_to be_valid
      end

      it "メールアドレスが256文字以上の場合は登録出来ないこと" do
        @user.email = "a" * 244 + "@example.com"
        expect(@user).not_to be_valid
      end

      it "重複したメールアドレスは登録出来ないこと" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        @user.save
        expect(duplicate_user).not_to be_valid
      end
    end
  end
end
