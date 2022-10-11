require 'active_support/core_ext/string/inflections'
require_relative 'employee'

# สร้าง SQLite view ที่สามารถ query ตามประเทศที่ทำงาน
regions = Employee.all.map(&:region).uniq
regions.each do |region|
  DB.create_or_replace_view("employees_region_#{region.parameterize(separator: '_')
  }".to_sym, DB[:employees].filter(region: region))
end

# สร้าง SQLite view สำหรับแบ่งตาม department
departments = Employee.all.map(&:department).uniq
departments.each do |department|
  DB.create_or_replace_view("employees_department_#{department.parameterize(separator: '_')}".to_sym, DB[:employees].filter(department: department))
end

# สร้าง SQLite view ที่สามารถ query ตามสัญชาติของพนักงาน
nationalities = Employee.all.map(&:nationality).uniq
nationalities.each do |nationality|
  DB.create_or_replace_view("employees_nationality_#{nationality.parameterize(separator: '_')}".to_sym, DB[:employees].filter(nationality: nationality))
end
