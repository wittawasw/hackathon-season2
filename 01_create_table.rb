require 'sequel'

DB = Sequel.sqlite('db/devclub.db')

DB.create_table :employees do
  primary_key :id,      auto_increment: true
  String  :employee_id, unique: true
  String  :passport,    unique: true
  String  :firstname
  String  :lastname
  Integer :gender
  Date    :birthdate
  String  :nationality
  Date    :hired
  String  :department
  String  :position
  Integer :status
  String  :region
end

