class AddColumnToEmployees < ActiveRecord::Migration
  def change
  end
  add_index :employees, :location_id
end
