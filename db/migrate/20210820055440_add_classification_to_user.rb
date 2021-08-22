class AddClassificationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :classification, :integer
  end
end
