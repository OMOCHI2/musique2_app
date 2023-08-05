require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  describe "GET /index" do
    context "有効な場合" do
      let(:user)   { FactoryBot.create(:user) }
      let(:stock)  { FactoryBot.create(:stock) }

      before do
        log_in user
      end

      it "ログインしているときはストックページに遷移すること" do
        get stocks_path
        expect(response).to have_http_status :success
      end
    end

    context "無効な場合" do
      it "未ログインのときはログインページにリダイレクトすること" do
        get stocks_path
        expect(response).to redirect_to login_path
      end

      it "フラッシュメッセージが表示されること" do
        get stocks_path
        expect(flash).to be_any
      end
    end
  end
end
