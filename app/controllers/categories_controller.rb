class CategoriesController < ApplicationController
  before_action :admin_user, only: [:new, :create]

  def index
    @category = Category.find_by(name: params[:name])
    if @category.nil?
      redirect_to posts_path
    else
      @posts = @category.posts.where(is_draft: false).paginate(page: params[:page])
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:name))
    if @category.save
      flash[:success] = "カテゴリーを追加しました"
      redirect_to new_category_path
    else
      render "new", status: :unprocessable_entity
    end
  end

  private
    def admin_user
      redirect_to(root_path, status: :see_other) unless current_user.admin?
    end
end
