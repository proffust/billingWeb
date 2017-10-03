class CreateNats < ActiveRecord::Migration[5.1]
  def change
    create_table :nats do |t|
      t.string :name
      t.integer :ext_port
      t.integer :int_port
      t.string :int_ip
      t.boolean :state
      t.string :owner

      t.timestamps
    end
    add_index :nats, :ext_port, unique: true
  end
end
