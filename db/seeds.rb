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

sql = File.open("db/seed_03_congress.sql").read
sql.split(';').each do |sql_statement|
  sql_statement.strip!
  if sql_statement.empty?
    next
  end
  ActiveRecord::Base.connection.execute(sql_statement)
end

sql = File.open("db/seed_04_senators.sql").read
sql.split(';').each do |sql_statement|
  sql_statement.strip!
  if sql_statement.empty?
    next
  end
  ActiveRecord::Base.connection.execute(sql_statement)
end

sql = File.open("db/seed_05_partylist.sql").read
sql.split(';').each do |sql_statement|
  sql_statement.strip!
  if sql_statement.empty?
    next
  end
  ActiveRecord::Base.connection.execute(sql_statement)
end

sql = File.open("db/seed_06_location_isocodes.sql").read
sql.split(';').each do |sql_statement|
  sql_statement.strip!
  if sql_statement.empty?
    next
  end
  ActiveRecord::Base.connection.execute(sql_statement)
end

# add denorm name of all locations
ActiveRecord::Base.connection.execute("update locations
set denorm_name = c.denorm_name
from (
select c.id, case when c.parent_id is null then c.name else CONCAT(c.name, ', ', p.name) end as denorm_name
        from locations c
            left join locations p on p.id = c.parent_id
) c
where c.id = locations.id")


