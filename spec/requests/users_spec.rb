require "rails_helper"

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

      before do
        ActionMailer::Base.deliveries.clear
      end

      it "登録されること" do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end

      it "ホーム画面にリダイレクトされること" do
        post users_path, params: user_params
        expect(response).to redirect_to root_path
      end

      it "フラッシュメッセージが表示されること" do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      it "登録時点では未ログイン状態であること" do
        post users_path, params: user_params
        expect(logged_in?).to be_falsey
      end

      it "メールが1件存在すること" do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it "登録時点ではアカウントが有効化されていないこと" do
        post users_path, params: user_params
        expect(User.last).not_to be_activated
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

  describe "GET /users/{id}" do
    let(:user) { FactoryBot.create(:user) }

    before do
      log_in user
    end

    it "returns http success" do
      get user_path(user)
      expect(response).to have_http_status :success
    end

    it "有効化されていないユーザーの場合はホーム画面にリダイレクトすること" do
      not_activated_user = FactoryBot.create(:not_activated_user)

      get user_path(not_activated_user)
      expect(response).to redirect_to root_path
    end
  end

  describe "GET /users/{id}/edit" do
    let(:user) { FactoryBot.create(:user) }

    it "タイトルが動的表示であること" do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include "アカウント設定 - MUSIQUE"
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
        expect(response.body).to include "アカウント設定 - MUSIQUE"
      end
    end

    context "未ログインの場合" do
      it "フラッシュメッセージが空でないこと" do
        patch user_path(user), params: { user: { name: user.name,
                                                 email: user.email } }
        expect(flash).not_to be_empty
      end

      it "未ログインユーザはログインページにリダイレクトされること" do
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

    context "管理者権限の検証" do
      let(:other_user) { FactoryBot.create(:other_user) }

      it "管理者権限は更新できないこと" do
        log_in other_user
        expect(other_user).not_to be_admin

        patch user_path(other_user), params: { user: { password: "foobar456",
                                                       password_confirmation: "foobar456",
                                                       admin: true } }
        other_user.reload
        expect(other_user).not_to be_admin
      end
    end
  end

  describe "DELETE /users/{id}" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:other_user) }

    context "管理者ユーザでログイン済みの場合" do
      it "削除できること" do
        log_in user
        expect { delete user_path(other_user) }.to change(User, :count).by -1
      end
    end

    context "未ログインの場合" do
      it "削除できないこと" do
        expect { delete user_path(user) }.not_to change(User, :count)
      end

      it "ログインページにリダイレクトすること" do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context "管理者ユーザでない場合" do
      it "削除できないこと" do
        log_in other_user
        expect { delete user_path(user) }.not_to change(User, :count)
      end

      it "ホーム画面にリダイレクトすること" do
        log_in other_user
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /users/{id}/following" do
    let(:user) { FactoryBot.create(:user) }

    it "未ログインならログインページにリダイレクトすること" do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

  describe "GET /users/{id}/followers" do
    let(:user) { FactoryBot.create(:user) }

    it "未ログインならログインページにリダイレクトすること" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
