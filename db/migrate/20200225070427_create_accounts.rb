# frozen_string_literal: true
class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :code
      t.string :name
      t.string :password

      t.timestamps
    end
  end
end
