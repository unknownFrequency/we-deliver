class RemoveIdFrom < ActiveRecord::Migration[5.1]
  def change
    remove_column :categories_products, :id
  end
end
