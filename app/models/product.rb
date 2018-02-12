class Product < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :brand, presence: true
  # validates :category, presence: true

  default_scope { order(name: :asc) }

  belongs_to :user
  belongs_to :brand
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories
  # accepts_nested_attributes_for :brand
end
