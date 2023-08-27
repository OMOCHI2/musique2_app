class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def show
    @user = User.find(params[:id])
    redirect_to root_path and return unless @user.activated?
    @posts = @user.posts.includes([:categories])
                        .where(is_draft: false)
                        .descending
                        .paginate(page: params[:page])
  end

  def new
    if logged_in?
      flash[:danger] = "無効な操作です"
      redirect_to root_path, status: :see_other
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウント認証メールを送信しました"
      redirect_to root_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "アカウント情報を更新しました"
      redirect_to user_path(@user)
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to root_path, status: :see_other
  end

  def following
    @title = "フォローリスト"
    @user  = User.find(params[:id])
    @users = @user.following.with_attached_image.paginate(page: params[:page])
    render "show_follow", status: :unprocessable_entity
  end

  def followers
    @title = "フォロワーリスト"
    @user  = User.find(params[:id])
    @users = @user.followers.with_attached_image.paginate(page: params[:page])
    render "show_follow", status: :unprocessable_entity
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "無効な操作です"
        redirect_to root_path, status: :see_other
      end
    end

    def admin_user
      redirect_to(root_path, status: :see_other) unless current_user.admin?
    end
end
