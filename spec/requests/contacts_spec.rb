require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  describe "GET /index" do
    before do
      get contact_path
    end

    it "正しく遷移できること" do
      expect(response).to have_http_status :success
    end

    it "それぞれの必要入力欄が表示されていること" do
      expect(response.body).to include "名前"
      expect(response.body).to include "メールアドレス"
      expect(response.body).to include "お問い合わせ内容"
    end

  end
end
