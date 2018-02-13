class AddStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :status, :string, default: "cart"

    Order.where(status: nil).update_all(status: "cart")
  end
end
