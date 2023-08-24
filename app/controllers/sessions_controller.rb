class SessionsController < ApplicationController

  def new
    if logged_in?
      flash[:warning] = "既にログインしています"
      redirect_to root_path, status: :see_other
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        log_in user
        redirect_to forwarding_url || user_path(user)
      else
        flash[:warning] = "アカウントを有効化していません。有効化メールを確認してください"
        redirect_to root_path
      end
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが違います"
      render "new", status: :unprocessable_entity
    end
  end

  def guest_login
    user = User.find_by(email: "guest@example.com")
    log_in user
    flash[:success] = "ゲストログインありがとうございます！管理者権限にてログインいたしました。
                        非管理者権限ログインは、お手数ですがgoogleログインか新規登録にてお願い致します。"
    redirect_to root_path
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end
end
