class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :brand, presence: true
  validates :category, presence: true

  default_scope { order(name: :asc) }
end
