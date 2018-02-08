class RemoveColumnsBrandAndCategoryFromProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :brand
    remove_column :products, :category
  end
end
