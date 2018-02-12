class CategoriesProduct < ApplicationRecord
  has_many :products
  has_many :categories

  validates :product_id, presence: true
  validates :category_id, presence: true
end
