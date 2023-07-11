class Post < ApplicationRecord
  has_rich_text :content
  belongs_to :user

  has_many :stocks, dependent: :destroy
  has_many :stock_users, through: :stocks, source: :user

  has_many :post_categories
  has_many :categories, through: :post_categories

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 255 }, on: :publicize
  validates :content, length: { maximum: 10000 }, on: :publicize

  scope :search, -> (search_param = nil) {
    return if search_param.blank?
    joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = posts.id AND action_text_rich_texts.record_type = 'Post'")
    .where("action_text_rich_texts.body LIKE ? OR posts.title LIKE ? ", "%#{search_param}%", "%#{search_param}%")
  }

  def stock(user)
    stocks.create(user_id: user.id)
  end

  def unstock(user)
    stocks.find_by(user_id: user.id).destroy
  end

  def stocked?(user)
    stock_users.include?(user)
  end
end
