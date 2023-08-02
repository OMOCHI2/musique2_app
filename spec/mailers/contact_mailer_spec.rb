require "rails_helper"

RSpec.describe ContactMailer, type: :mailer do
  contact = Contact.new(name:    "Contact Tester",
                        email:   "contacttest@example.com",
                        content: "お問い合わせのテストです")
  let(:mail)      { ContactMailer.send_mail(contact) }
  let(:mail_body) { mail.body.encoded.split(/\r\n/).map{|i| Base64.decode64(i)}.join }

  it "指定したタイトルで送信されること" do
    expect(mail.subject).to eq "Webサイト「MUSIQUE」より問い合わせが届きました"
  end

  it "送信先がsatsukisama.mochi@gmail.comであること" do
    expect(mail.to).to eq ["satsukisama.mochi@gmail.com"]
  end

  it "送信元が入力したメールアドレスであること" do
    expect(mail.from).to eq [contact.email]
  end

  it "本文に問い合わせ者の名前が表示されていること" do
    expect(mail_body).to match contact.name
  end

  it "本文に入力した問い合わせ内容が表示されていること" do
    expect(mail_body).to match contact.content.encode.split(/\r\n/).map{|i| Base64.decode64(i)}.join
  end

  it "本文にユーザーのメールアドレスが表示されていること" do
    expect(mail_body).to match contact.email
  end
end
