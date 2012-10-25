class CreateEmpleadosUsersTable < ActiveRecord::Migration
  def up
    create_table :empleados_users, :id => false do |t|
        t.integer :empleado_id
        t.integer :user_id
    end
    add_index :empleados_users, [:empleado_id, :user_id]
    add_index :empleados_users, [:user_id, :empleado_id]
  end

  def down
  end
end
