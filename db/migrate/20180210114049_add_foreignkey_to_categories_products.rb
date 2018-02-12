class AddForeignkeyToCategoriesProducts < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :categories_products, :product_id
    add_foreign_key :categories_products, :category_id
  end
end
