class GoogleLoginApiController < ApplicationController
  require 'googleauth/id_tokens/verifier'

  protect_from_forgery except: :callback
  before_action :verify_g_csrf_token

  def callback
    payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: ENV['YOUR GOOGLE CLIENT ID'])
    user = User.find_or_create_by(email: payload['email'])
    if user.name == nil
      user.name = payload['name']
      user.password = user.new_token
      user.save
      user.activate
    end
    log_in user
    flash[:info] = "ログインしました"
    redirect_to root_path
  end

  private

    def verify_g_csrf_token
      if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
        redirect_to root_path, notice: '不正なアクセスです'
      end
    end
end
