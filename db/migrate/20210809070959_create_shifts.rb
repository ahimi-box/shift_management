class CreateShifts < ActiveRecord::Migration[5.1]
  def change
    create_table :shifts do |t|
      t.date :worked_on
      t.datetime :start_time
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :desired_attendance_time
      t.datetime :desired_leave_time
      t.string :user_memo
      t.datetime :determined_arrival_time
      t.datetime :decided_leaving_time
      t.string :admin_memo
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
