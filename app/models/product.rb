class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :brand, presence: true
  # validates :category, presence: true

  default_scope { order(name: :asc) }

  belongs_to :user
  # has_many :categories
  belongs_to :brand
  accepts_nested_attributes_for :brand
end
