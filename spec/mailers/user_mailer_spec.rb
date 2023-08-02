require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  describe "account_activation" do
    let(:mail)      { UserMailer.account_activation(user) }
    # メールのbodyをデコードして比較できるようにする
    let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }

    before do
      user.activation_token = User.new_token
    end

    it "アカウントアクティベーションというタイトルで送信されること" do
      expect(mail.subject).to eq "アカウントアクティベーション"
    end

    it "送信先がrails@example.comであること" do
      expect(mail.to).to eq [user.email]
    end

    it "送信元がsatsukisama.mochi@gmail.comであること" do
      expect(mail.from).to eq ["satsukisama.mochi@gmail.com"]
    end

    it "本文にユーザー名が表示されていること" do
      expect(mail_body).to match user.name
      binding.pry
    end

    it "本文にユーザーのactivation_tokenが表示されていること" do
      expect(mail_body).to match user.activation_token
    end

    it "本文にユーザーのメールアドレスが表示されていること" do
      expect(mail_body).to match CGI.escape(user.email)
    end
  end

  describe "password_reset" do
    let(:mail)      { UserMailer.password_reset(user) }
    let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }

    before do
      user.reset_token = User.new_token
    end

    it "パスワードの再設定というタイトルで送信されること" do
      expect(mail.subject).to eq "パスワードの再設定"
    end

    it "送信先がrails@example.comであること" do
      expect(mail.to).to eq [user.email]
    end

    it "送信元がsatsukisama.mochi@gmail.comであること" do
      expect(mail.from).to eq ["satsukisama.mochi@gmail.com"]
    end

    it "メール本文にreset_tokenが表示されていること" do
      expect(mail_body).to match user.reset_token
    end

    it "メール本文にユーザーのメールアドレスが表示されていること" do
      expect(mail_body).to match CGI.escape(user.email)
    end
  end
end
