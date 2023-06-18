require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    before do
      user.activation_token = User.new_token
    end

    it "アカウントアクティベーションというタイトルで送信されること" do
      expect(mail.subject).to eq "アカウントアクティベーション"
    end

    it "送信先がto@example.orgであること" do
      expect(mail.to).to eq [user.email]
    end

    it "送信元がsatsukisama.mochi@gmail.comであること" do
      expect(mail.from).to eq ["satsukisama.mochi@gmail.com"]
    end

    it "本文にユーザ名が表示されていること" do
      expect(mail.body.encoded).to match user.name
    end

    it "本文にユーザのactivation_tokenが表示されていること" do
      expect(mail.body.encoded).to match user.activation_token
    end

    it "本文にユーザーのメールアドレスが表示されていること" do
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end
