class CreateTableBrand < ActiveRecord::Migration[5.1]
  def change
    create_table :brands do |t|
      t.string :name
      add_reference :products, :brands
    end
  end
end
