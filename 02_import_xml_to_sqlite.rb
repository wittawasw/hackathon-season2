require 'active_support/isolated_execution_state'
require 'active_support/xml_mini'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/integer'
require 'active_support/core_ext/time'
require_relative 'employee'

ActiveSupport::XmlMini.backend = 'LibXML'

xml_source_file = './data-devclub-1.xml'.freeze
xml_file = File.open(xml_source_file)

employees = Hash.from_xml(xml_file)['records']['record']

cleaned_employees = employees.select do |employee|
  ['1', '3'].include?(employee['STATUS']) &&
  ['0', '1'].include?(employee['GENDER']) &&
  employee['EMPID'] != employee['PASSPORT']
end

migrated_employees = cleaned_employees.select do |employee|
  ["Pilot", "Steward", "Airhostess"].include?(employee['POSITION']) &&
  Date.parse(employee['HIRED']) < 3.years.ago
end

migrated_employees.each do |employee|
  upsert_employee(employee)
end

def upsert_employee(employee)
  Employee.find_or_create(employee_id: employee['EMPID'],
    passport: employee['PASSPORT'],
    firstname: employee['FIRSTNAME'],
    lastname: employee['LASTNAME'],
    gender: employee['GENDER'],
    birthdate: Date.parse(employee['BIRTHDAY']),
    nationality: employee['NATIONALITY'],
    hired: Date.parse(employee['HIRED']),
    department: employee['DEPT'],
    position: employee['POSITION'],
    status: employee['STATUS'],
    region: employee['REGION']
  )
rescue
end
