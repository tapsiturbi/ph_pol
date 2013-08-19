# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.connection.execute("delete from careers")
ActiveRecord::Base.connection.execute("delete from politicians")
ActiveRecord::Base.connection.execute("delete from locations")

sql = File.open("db/seed_01_provincial.sql").read
sql.split(';').each do |sql_statement|
  sql_statement.strip!
  if sql_statement.empty?
    next
  end
  #puts sql_statement
  ActiveRecord::Base.connection.execute(sql_statement)
end

sql = File.open("db/seed_02_municipal.sql").read
sql.split(';').each do |sql_statement|
  sql_statement.strip!
  if sql_statement.empty?
    next
  end
  ActiveRecord::Base.connection.execute(sql_statement)
end
