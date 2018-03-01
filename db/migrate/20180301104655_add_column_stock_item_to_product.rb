class AddColumnStockItemToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :stock_item, :boolean, default: :true
  end
end
