class AddApplyCheckToShift < ActiveRecord::Migration[5.1]
  def change
    add_column :shifts, :apply_check, :boolean
  end
end
