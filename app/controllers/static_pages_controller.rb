class StaticPagesController < ApplicationController
  MAX_GET_POSTS = 10

  def home
    if logged_in?
      @following_users_posts = Post.where(user_id: [*current_user.following_ids], is_draft: false)
                                   .limit(MAX_GET_POSTS)
                                   .descending
    end
    @popular_posts = Post.find(Stock.group(:post_id)
                                    .order("count(post_id) desc")
                                    .limit(MAX_GET_POSTS)
                                    .pluck(:post_id)
                              )
    @random_posts =  Post.where(is_draft: false).order("RANDOM()").limit(MAX_GET_POSTS)
    @categories = Category.all
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
