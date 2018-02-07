class MakePhonePrimaryLogin < ActiveRecord::Migration[5.1]
  def change
    remove_index(:users, :email)
    change_column :users, :email, :string, :null => true
  end
end
