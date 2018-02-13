class AddDeliveryAddressToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :delivery_address, :string
  end
end
