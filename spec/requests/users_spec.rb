require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status :success
    end
  end

  describe "POST /users #create" do
    context "有効な値の場合" do
      let(:user_params) { { user: { name: "Example User",
                                    email: "user@example.com",
                                    password: "foobar123",
                                    password_confirmation: "foobar123" } } }

      it "登録されること" do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end

      it "ユーザー詳細ページにリダイレクトされること" do
        post users_path, params: user_params
        user = User.last
        expect(response).to redirect_to user_path(user)
      end

      it "flashが表示されること" do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      it "ログイン状態であること" do
        post users_path, params: user_params
        expect(logged_in?).to be_truthy
      end
    end

    it "無効な値だと登録されないこと" do
      expect {
        post users_path, params: { user: { name: "invalid",
                                           email: "invlid@example.com",
                                           password: "foobar",
                                           password_confirmation: "barbaz" } }
        }.not_to change(User, :count)
    end
  end

end
