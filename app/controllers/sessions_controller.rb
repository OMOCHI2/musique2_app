class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      reset_session
      log_in user
      flash[:success] = "ログインしました"
      redirect_to root_path
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが違います"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end
end
