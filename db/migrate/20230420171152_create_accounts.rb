# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :number
      t.decimal :balance, precision: 10, scale: 2
      t.boolean :main

      t.timestamps
    end
  end
end
