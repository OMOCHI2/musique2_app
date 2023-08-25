class PostCategory < ApplicationRecord
  belongs_to :post
  belongs_to :category

  validates :category_id, presence: true
end
