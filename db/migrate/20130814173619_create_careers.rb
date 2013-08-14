class CreateCareers < ActiveRecord::Migration
  def change
    create_table :careers do |t|
      t.datetime :start_date, :null => false
      t.datetime :end_date
      t.string :title

      t.belongs_to :politician, index: true
      t.belongs_to :location, index: true

      t.timestamps
    end
  end
end
