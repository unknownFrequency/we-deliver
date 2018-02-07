class AddNameAndAddressToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column(:users, :name, :string)  
    add_column(:users, :address, :string)  
    add_column(:users, :zip, :integer)  
  end
end
