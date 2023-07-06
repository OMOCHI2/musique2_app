class Post < ApplicationRecord
  has_rich_text :content
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 255 },   on: :publicize
  validates :content, length: { maximum: 10000 }, on: :publicize

  scope :search, -> (search_param = nil) {
    return if search_param.blank?
    joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = posts.id AND action_text_rich_texts.record_type = 'Post'")
    .where("action_text_rich_texts.body LIKE ? OR posts.title LIKE ? ", "%#{search_param}%", "%#{search_param}%")
  }
end
