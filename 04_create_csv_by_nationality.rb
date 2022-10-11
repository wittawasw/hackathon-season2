require 'active_support/core_ext/string/inflections'
require 'csv'
require_relative 'employee'

# สร้างไฟล์ CSV แยกตามสัญชาติของพนักงาน
nationalities = Employee.all.map(&:nationality).uniq
nationalities.each do |nationality|
  csv_file = "csv/employees_nationality_#{nationality.parameterize(separator: '_')}.csv"
  view_name = "employees_nationality_#{nationality.parameterize(separator: '_')}"

  CSV.open(csv_file, "wb") do |csv|
    csv << DB["select * from #{view_name}"].columns
  end

  DB["select * from #{view_name}"].each do |row|
    CSV.open(csv_file, "a+") do |csv|
      csv << row.values
    end
  end
end
