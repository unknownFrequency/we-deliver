class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.decimal :total, precision: 15, scale: 2, null: false
    end
  end
end
