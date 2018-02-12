class ChangeCloumnPriceOnProductToDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :price, :decimal, :precision => 15, :scale  => 2
  end
end
