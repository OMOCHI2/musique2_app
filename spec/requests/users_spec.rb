require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status :success
    end
  end

  describe "POST /users" do
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

  describe "PATCH /users" do
    let!(:user) { FactoryBot.create(:user) }

    context "無効な値の場合" do
      it "更新できないこと" do
        patch user_path(user), params: { user: { name: "invalid",
                                                 email: "invalid@example.com",
                                                 password: "foobar",
                                                 password_confirmation: "barbaz" } }
        user.reload
        expect(user.name).not_to eq "invalid"
        expect(user.email).to_not eq "invalid@example.com"
        expect(user.password).to_not eq "foobar"
        expect(user.password_confirmation).to_not eq "barbaz"
      end

      it "更新後にeditページが表示されていること" do
        get edit_user_path(user)
        patch user_path(user), params: { user: { name: "invalid",
                                                 email: "invalid@example.com",
                                                 password: "foobar",
                                                 password_confirmation: "barbaz" } }
        expect(response.body).to include "アカウント設定 - Musique"
      end
    end
  end

end
