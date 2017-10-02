class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :address
      t.boolean :is_router
      t.date :date_of_disconnect
      t.boolean :access_state

      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :address, unique: true
  end
end
