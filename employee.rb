require 'sequel'

DB = Sequel.sqlite('db/devclub.db')

class Employee < Sequel::Model
end
