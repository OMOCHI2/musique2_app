class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "正常に投稿されました"
      redirect_to root_path
    else
      render "static_pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "削除しました"
    if request.referrer.nil?
      redirect_to root_path, status: :see_other
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:title, :content)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_path, status: :see_other if @post.nil?
    end
end
