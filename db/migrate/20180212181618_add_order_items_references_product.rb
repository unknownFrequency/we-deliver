class AddOrderItemsReferencesProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :order_items, :product, index: true
  end
end
