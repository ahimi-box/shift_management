# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210829141728) do

  create_table "administrators", force: :cascade do |t|
    t.string "notice"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id"
  end

  create_table "shifts", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "start_time"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "desired_attendance_time"
    t.datetime "desired_leave_time"
    t.string "user_memo"
    t.datetime "determined_arrival_time"
    t.datetime "decided_leaving_time"
    t.string "admin_memo"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "apply_check"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "employment_status"
    t.integer "employee_number"
    t.boolean "admin"
    t.datetime "basic_time", default: "2021-09-20 08:00:00"
    t.datetime "basic_startwork_time", default: "2021-09-20 08:30:00"
    t.datetime "basic_finishwork_time", default: "2021-09-20 18:30:00"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "classification"
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_number"], name: "index_users_on_employee_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
