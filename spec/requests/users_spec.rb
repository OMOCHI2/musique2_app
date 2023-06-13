require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe 'GET /users' do
    it "ログインしていなければログインページにリダイレクトすること" do
      get users_path
      expect(response).to redirect_to login_path
    end
  end

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

      it "フラッシュメッセージが表示されること" do
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

  describe "get /users/{id}/edit" do
    let(:user) { FactoryBot.create(:user) }

    it "タイトルが動的表示であること" do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include "アカウント設定 - Musique"
    end

    context "未ログインの場合" do
      it "フラッシュメッセージが空でないこと" do
        get edit_user_path(user)
        expect(flash).not_to be_empty
      end

      it "ログインすると直前に開こうとしていたページにリダイレクトされること" do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context "別のユーザの場合" do
      let(:other_user) { FactoryBot.create(:other_user) }

      it "フラッシュメッセージが表示されていること" do
        log_in user
        get edit_user_path(other_user)
        expect(flash).to be_any
      end

      it "ホーム画面にリダイレクトされること" do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH /users" do
    let(:user) { FactoryBot.create(:user) }

    context "有効な値の場合" do
      before do
        log_in user
        @name =  "Foo Bar"
        @email = "foo@bar.com"
        patch user_path(user), params: { user: { name: @name,
                                                 email: @email,
                                                 password: "",
                                                 password_confirmation: "" } }
      end

      it "更新できること" do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it "ユーザー詳細ページにリダイレクトすること" do
        expect(response).to redirect_to user
      end

      it "フラッシュメッセージが表示されていること" do
        expect(flash).to be_any
      end
    end

    context "無効な値の場合" do
      before do
        log_in user
        patch user_path(user), params: { user: { name: "invalid",
                                                 email: "invalid@example.com",
                                                 password: "foobar",
                                                 password_confirmation: "barbaz" } }
      end

      it "更新できないこと" do
        user.reload
        expect(user.name).not_to eq "invalid"
        expect(user.email).not_to eq "invalid@example.com"
        expect(user.password).not_to eq "foobar"
        expect(user.password_confirmation).not_to eq "barbaz"
      end

      it "更新後にeditページが表示されていること" do
        expect(response.body).to include "アカウント設定 - Musique"
      end
    end

    context "未ログインの場合" do
      it "フラッシュメッセージが空でないこと" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).not_to be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    context "別のユーザの場合" do
      let(:other_user) { FactoryBot.create(:other_user) }

      before do
        log_in user
        patch user_path(other_user), params: { user: { name: other_user.name,
                                                       email: other_user.email } }
      end

      it "フラッシュメッセージが表示されていること" do
        expect(flash).to be_any
      end

      it "ホーム画面にリダイレクトすること" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
