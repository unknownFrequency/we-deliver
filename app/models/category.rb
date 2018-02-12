class Category < ApplicationRecord
  has_many :products, through: :categories_products
end
