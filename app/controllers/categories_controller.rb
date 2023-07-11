class CategoriesController < ApplicationController
  def index
    @category = Category.find_by(name: params[:name])
    if @category.nil?
      redirect_to root_path
    else
      @posts = @category.posts
    end
  end
end
