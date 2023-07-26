class StaticPagesController < ApplicationController
  MAX_GET_POSTS = 10

  def home
    if logged_in?
      # @post = current_user.posts.build
      @following_users_posts = Post.where(user_id: [*current_user.following_ids], is_draft: false)
                                   .limit(MAX_GET_POSTS)
                                   .order(created_at: :desc)
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

  def company
  end

  def jobs
  end
end
