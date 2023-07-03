class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true
end
