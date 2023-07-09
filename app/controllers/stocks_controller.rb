class StocksController < ApplicationController

  def index
  end

  def create
    @post = Post.find(params[:post_id])
    unless @post.stocked?(current_user)
      @post.stock(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.turbo_stream
      end
    end
  end

  def destroy
    @post = Stock.find(params[:id]).post
    if @post.stocked?(current_user)
      @post.unstock(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || root_url }
        format.turbo_stream
      end
    end
  end
end
