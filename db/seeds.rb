# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
email = ENV['ADMIN_EMAIL']
userExists = User.find_by(email: email)
if userExists.nil?
  user = User.new
  user.email = email
  user.first_name = ENV['ADMIN_FIRST_NAME']
  user.last_name = ENV['ADMIN_LAST_NAME']
  user.password = ENV['ADMIN_PASSWORD']
  user.password_confirmation = ENV['ADMIN_PASSWORD']
  user.user_type = 'admin'
  user.save!
else
  puts "User with the given properties already exists, either change the email or delete the user."
end