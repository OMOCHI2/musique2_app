class SessionsController < ApplicationController
  def new
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
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, status: :see_other
  end
end
