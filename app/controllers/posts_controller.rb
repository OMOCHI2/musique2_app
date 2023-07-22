class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy, :draft]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def index
    @title = params[:keyword]
    @posts = Post.where(is_draft: false).search(params[:keyword]).paginate(page: params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:publish]
      if @post.save(context: :publicize)
        flash[:success] = "正常に記事が投稿されました！"
        redirect_to user_path(current_user)
      else
        flash.now[:danger] = "記事を投稿できませんでした。入力内容を確認してください"
        render "new", status: :unprocessable_entity
      end
    else
      if @post.update_attribute(:is_draft, true)
        flash[:success] = "下書きを保存しました"
        redirect_to user_path(current_user)
      else
        flash.now[:danger] = "下書きを保存できませんでした。入力内容を確認してください"
        render "new", status: :unprocessable_entity
      end
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
  end

  def update
    if params[:publish_from_draft]
      @post.attributes = post_params.merge(is_draft: false)

      if @post.save(context: :publicize)
        flash[:success] = "下書き記事を公開しました！"
        redirect_to user_path(current_user)
      else
        @post.is_draft = true
        flash.now[:danger] = "記事を公開できませんでした。入力内容を確認してください"
        render "edit", status: :unprocessable_entity
      end

    elsif params[:update_post]
      @post.attributes = post_params

      if @post.save(context: :publicize)
        flash[:success] = "記事を更新しました！"
        redirect_to post_path(@post)
      else
        flash.now[:danger] = "記事を更新できませんでした。入力内容を確認してください"
        render "edit", status: :unprocessable_entity
      end

    else
      if @post.update(post_params)
        flash[:success] = "下書きを更新しました！"
        redirect_to user_path(current_user)
      else
        flash.now[:danger] = "下書きを更新できませんでした。入力内容を確認してください"
        render "edit", status: :unprocessable_entity, alert: "登録できませんでした"
      end
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "記事を削除しました"
    redirect_to user_path(current_user)
  end

  def draft
    @posts = current_user.posts.where(is_draft: true).paginate(page: params[:page])
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :publish, :is_draft, category_ids: [])
    end

    def correct_user
      unless @post = current_user.posts.find_by(id: params[:id])
        flash[:warning] = "無効な操作です"
        redirect_to root_path, status: :see_other
      end
    end
end
