class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "アカウント有効化に成功しました"
      redirect_to user_path(user)
    else
      flash[:danger] = "無効な有効化URLです"
      redirect_to root_path
    end
  end
end
