require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "GET /new" do
    it "name属性がpassword_reset[email]のinputタグが表示されること" do
      get new_password_reset_path
      expect(response.body).to include "name=\"password_reset[email]\""
    end
  end

  describe "POST /password_resets" do
    it "無効なメールアドレスのときはフラッシュメッセージが存在すること" do
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash).not_to be_empty
    end

    context "有効なメールアドレスの場合" do
      it "reset_digestが変わっていること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(user.reset_digest).not_to eq user.reload.reset_digest
      end

      it "送信メールが1件増えること" do
        expect {
          post password_resets_path, params: { password_reset: { email: user.email } }
        }.to change(ActionMailer::Base.deliveries, :count).by 1
      end

      it "フラッシュメッセージが存在すること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(flash).not_to be_empty
      end

      it "ホーム画面にリダイレクトされること" do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /edit" do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get("@user")
    end

    it "メールアドレスもトークンも有効なら、隠しフィールドにメールアドレスが表示されること" do
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response.body).to include "<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\""
    end

    it "メールアドレスが間違っていれば、ホーム画面にリダイレクトすること" do
      get edit_password_reset_path(@user.reset_token, email: "")
      expect(response).to redirect_to root_path
    end

    it "無効なユーザーならホーム画面にリダイレクトすること" do
      @user.toggle!(:activated)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to root_path
    end

    it "トークンが無効なら、ホーム画面にリダイレクトすること" do
      get edit_password_reset_path("wrong token", email: @user.email)
      expect(response).to redirect_to root_path
    end

    it "2時間以上経過していれば、newにリダイレクトされること" do
      @user.update_attribute(:reset_sent_at, 3.hours.ago)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to new_password_reset_path
    end
  end

  describe "PATCH /password_resets" do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get("@user")
    end

    context "有効なパスワードの場合" do
      before do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                      user: { password: "foobaz123",
                                                              password_confirmation: "foobaz123" } }
      end

      it "ログイン状態になること" do
        expect(logged_in?).to be_truthy
      end

      it "フラッシュメッセージが存在すること" do
        expect(flash).to_not be_empty
      end

      it "ユーザーの詳細ページにリダイレクトすること" do
        expect(response).to redirect_to user_path(@user)
      end

      it "reset_digestがnilになること" do
        @user.reload
        expect(@user.reset_digest).to be_nil
      end
    end

    it "パスワードと確認用パスワードが一致しなければ、エラーメッセージが表示されること" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: "foobaz123",
                                                                      password_confirmation: "barbaz456" } }
      expect(response.body).to include "<div id=\"error_explanation\">"
    end

    it "パスワードが空なら、エラーメッセージが表示されること" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: "",
                                                                      password_confirmation: "" } }
      expect(response.body).to include "<div id=\"error_explanation\">"
    end

    context "2時間以上経過している場合" do
      before do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                      user: { password: "foobaz123",
                                                              password_confirmation: "foobaz123" } }
      end

      it "newにリダイレクトされること" do
        expect(response).to redirect_to new_password_reset_path
      end

      it "期限切れを伝えるフラッシュメッセージが表示されること" do
        follow_redirect!
        expect(response.body).to include "パスワード再設定用リンクが期限切れです"
      end
    end
  end
end
