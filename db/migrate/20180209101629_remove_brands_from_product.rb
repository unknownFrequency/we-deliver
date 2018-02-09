class RemoveBrandsFromProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :brands_id, :integer
    remove_column :products, :brand, :string
    remove_column :products, :category, :string
  end
end
