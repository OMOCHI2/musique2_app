class Stock < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :post_id, presence: true

  def self.get_stock_posts(user)
    self.includes([:post, post: [:rich_text_content, :user, :categories, user: :image_attachment]])
        .where(user_id: user.id).map(&:post)
  end
end
