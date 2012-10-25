# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'CREATING ROLES'
Role.create([
  { :name => 'admin' }, 
  { :name => 'jefe' }, 
  { :name => 'user' }
], :without_protection => true)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Raul Sanchez', :email => 'raul@um.es', :password => 'qwerty123', :password_confirmation => 'qwerty123'
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Raul Sanchez 2', :email => 'raulxininen@gmail.com', :password => 'qwerty123', :password_confirmation => 'qwerty123'
puts 'New user created: ' << user2.name

user3 = User.create! :name => 'Raul Sanchez 3', :email => 'raul3@um.es', :password => 'qwerty123', :password_confirmation => 'qwerty123'

user.add_role :admin
user2.add_role :jefe
user3.add_role :user


