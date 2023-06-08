require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar123", password_confirmation: "foobar123")
  end

  describe "ユーザーの新規登録" do
    context "新規登録がうまくいくとき" do
      it "内容に問題がないこと" do
        expect(@user).to be_valid
      end
    end

    context "新規登録がうまくいかないとき" do
      it "nameが空のときは登録出来ないこと" do
        @user.name = "     "
        expect(@user).not_to be_valid
      end

      it "emailが空のときは登録出来ないこと" do
        @user.email = "     "
        expect(@user).not_to be_valid
      end

      it "nameが31文字以上の場合は登録出来ないこと" do
        @user.name = "a" * 31
        expect(@user).not_to be_valid
      end

      it "emailが256文字以上の場合は登録出来ないこと" do
        @user.email = "a" * 244 + "@example.com"
        expect(@user).not_to be_valid
      end

      it "重複したemailは登録出来ないこと" do
        duplicate_user = @user.dup
        @user.save
        expect(duplicate_user).not_to be_valid
      end

      it "passwordが空では登録出来ないこと" do
        @user.password = @user.password_confirmation = ""
        expect(@user).not_to be_valid
      end

      it "passwordが7文字以下では登録出来ないこと" do
        @user.password = @user.password_confirmation = "foobar1"
        expect(@user).not_to be_valid
      end

      it "passwordが存在してもpassword_confirmationが空では登録出来ないこと" do
        @user.password_confirmation = ""
        expect(@user).not_to be_valid
      end

      it "passwordは半角英数字混合でなければ登録出来ないこと" do
        @user.password = @user.password_confirmation = "foobarbaz"
        expect(@user).not_to be_valid
      end
    end
  end

  describe "コールバックメソッドの検証" do
    it "メールアドレスは小文字で保存されること" do
      @user.email = "Foo@ExAMPle.CoM"
      @user.save
      expect(@user.reload.email).to eq "foo@example.com"
    end
  end

  describe "passwordの検証" do
    it "passwordとpassword_confirmationが一致しない場合は無効となること" do
      @user.password_confirmation = "foobar456"
      expect(@user).not_to be_valid
    end

    it 'passwordが暗号化されていること' do
      expect(@user.encrypted_attributes).not_to eq "foobar123"
    end
  end
end
