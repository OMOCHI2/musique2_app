class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @categories = Category.all
    end
  end

  def help
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def contact
  end
end
