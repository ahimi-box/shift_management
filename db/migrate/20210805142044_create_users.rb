class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.string :employment_status
      t.integer :employee_number
      t.boolean :admin
      t.datetime :basic_time, default: Time.current.change(hour: 8, min: 0, sec: 0)
      t.datetime :basic_startwork_time, default: Time.current.change(hour: 8, min: 30, sec: 0)
      t.datetime :basic_finishwork_time, default: Time.current.change(hour: 18, min: 30, sec: 0)

      t.timestamps
    end
  end
end
