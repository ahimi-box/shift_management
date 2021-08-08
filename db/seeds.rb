# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# coding: utf-8

User.create!( name: "管理者",
  email: "admin@email.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  employee_number: "0"
)

# User.create!( name: "社員1",
#   email: "sample@email.com",
#   password: "password",
#   password_confirmation: "password",
#   employment_status: "正社員",
#   employee_number: "1",
#   uid: "1")

5.times do |n|
  Faker::Config.locale = :ja
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  employee_number = "#{n+1}"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password,
                employee_number: employee_number
                )
end    
