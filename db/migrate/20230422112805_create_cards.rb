class CreateCards < ActiveRecord::Migration[7.0]
  change_table :accounts do |t|
    t.change :number, :string, index: { unique: true }
  end

  def change
    create_table :cards do |t|
      t.belongs_to :account, null: true, index: { unique: true }, foreign_key: true
      t.string :number
      t.string :cvv, limit: 3
      t.date :end_date

      t.timestamps
    end
  end
end
