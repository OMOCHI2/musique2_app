class Post < ApplicationRecord
  has_rich_text :content
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  with_options presence: true, on: :publicize do
    validates :title
    validates :content
  end
  validates :title,   length: { maximum: 255 },   on: :publicize
  validates :content, length: { maximum: 10000 }, on: :publicize
end
