require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  before do
    get contact_path
  end

  describe "GET /index" do
    it "正しく遷移できること" do
      expect(response).to have_http_status :success
    end

    it "タイトルが動的表示であること" do
      expect(response.body).to include "お問い合わせ - MUSIQUE"
    end

    it "それぞれの必要入力欄が表示されていること" do
      expect(response.body).to include "名前"
      expect(response.body).to include "メールアドレス"
      expect(response.body).to include "お問い合わせ内容"
    end
  end

  describe "post /confirm" do
    it "有効なときはconfirmへrenderされること" do
      post contact_confirm_path, params: { contact: { name:    "Test User",
                                                      email:   "test@example.com",
                                                      content: "Test content" } }
      expect(response).to have_http_status(422)
      expect(response.body).to include "この内容で送信します。よろしいですか？"
    end

    it "無効なときはconfirmへ遷移せず、indexへrenderされること" do
      post contact_confirm_path, params: { contact: { name:    "Invalid Man",
                                                      email:   "invalid.example.com",
                                                      content: "" } }
      expect(response).to have_http_status(422)
      expect(response.body).not_to include "この内容で送信します。よろしいですか？"
    end
  end

  describe "post /done" do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it "送信ボタンを押下したときはdoneへrenderされること" do
      post contact_done_path, params: { contact: { name:    "Test User",
                                                   email:   "test@example.com",
                                                   content: "Test content" } }
      expect(response).to have_http_status(422)
      expect(response.body).to include "ありがとうございます。お問い合わせ内容を送信しました。"
    end

    it "送信ボタンを押下したときはメールが１件増えること" do
      post contact_done_path, params: { contact: { name:    "Test User",
                                                   email:   "test@example.com",
                                                   content: "Test content" } }
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it "戻るボタンを押下したときはindexへrenderされること" do
      post contact_done_path, params: { contact: { name:    "Test User",
                                                   email:   "test@example.com",
                                                   content: "Test content" },
                                        back:    { name:    "戻る" }
                                      }
      expect(response).to have_http_status(422)
      expect(response.body).not_to include "ありがとうございます。お問い合わせ内容を送信しました。"
    end

    it "戻るボタンを押下したときはメールは増えないこと" do
      post contact_done_path, params: { contact: { name:    "Test User",
                                                   email:   "test@example.com",
                                                   content: "Test content" },
                                        back:    { name:    "戻る" }
                                      }
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end
  end
end
