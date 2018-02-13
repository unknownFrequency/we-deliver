class AddColumnZipToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :zip, :integer
  end
end
