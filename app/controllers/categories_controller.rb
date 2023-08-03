class CategoriesController < ApplicationController

  def index
    @category = Category.find_by(name: params[:name])
    if @category.nil?
      redirect_to posts_path
    else
      @posts = @category.posts.where(is_draft: false).paginate(page: params[:page])
    end
  end
end
