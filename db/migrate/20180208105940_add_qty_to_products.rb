class AddQtyToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :qty, :integer, null: false, default: 0
  end
end
