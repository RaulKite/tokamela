class AddJefeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :jefe_id, :integer
  end
end
