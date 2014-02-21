class AddDenormSortToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :denorm_sort, :string

    reversible do |dir|
      dir.up do
        execute <<-SQL
          update locations
          set denorm_sort = c.denorm_sort
          from (
          select c.id, case when c.parent_id is null then c.name else CONCAT(p.name, '||', c.name) end as denorm_sort
                  from locations c
                      left join locations p on p.id = c.parent_id
          ) c
          where c.id = locations.id
        SQL
      end
    end
  end
end
