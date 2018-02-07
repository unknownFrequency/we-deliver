class ChangeColumnEmailToNotDefaultToEmptyString < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :email, :string, default: nil
  end
end
