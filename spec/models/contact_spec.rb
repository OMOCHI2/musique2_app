require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { Contact.new(name:    "Example User",
                              email:   "user@example.com",
                              content: "Sample Content") }

  it "有効であること" do
    expect(contact).to be_valid
  end

  context "無効の場合" do
    it "名前が空のときは送信できないこと" do
      contact.name = ""
      expect(contact).not_to be_valid
    end

    it "名前が30文字より長いときは送信できないこと" do
      contact.name = "a" * 31
      expect(contact).not_to be_valid
    end

    it "メールアドレスが空のときは送信できないこと" do
      contact.email = ""
      expect(contact).not_to be_valid
    end

    it "メールアドレスが255文字より長いときは送信できないこと" do
      contact.email = "a" * 244 + "@example.com"
      expect(contact).not_to be_valid
    end

    it "メールアドレスが不正なときは送信できないこと" do
      contact.email = "invalid.example.com"
      expect(contact).not_to be_valid
    end

    it "お問い合わせ内容が空のときは送信できないこと" do
      contact.content = ""
      expect(contact).not_to be_valid
    end

    it "メールアドレスが1000文字より長いときは送信できないこと" do
      contact.content = "a" * 10001
      expect(contact).not_to be_valid
    end
  end
end
