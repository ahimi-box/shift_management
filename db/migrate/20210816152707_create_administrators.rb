class CreateAdministrators < ActiveRecord::Migration[5.1]
  def change
    create_table :administrators do |t|
      t.string :notice
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
