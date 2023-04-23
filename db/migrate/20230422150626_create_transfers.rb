class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.datetime :operation_time
      t.integer :operation_type
      t.references :source_account, null: true, foreign_key: { to_table: :accounts }
      t.references :dest_account, null: true, foreign_key: { to_table: :accounts }
      t.decimal :sum, precision: 10, scale: 2
      t.string :comment

      t.timestamps
    end
  end
end
