class AddIndexReferencesBrandsToProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :brand
  end
end
