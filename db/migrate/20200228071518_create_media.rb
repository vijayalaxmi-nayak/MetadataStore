# frozen_string_literal: true
class CreateMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :media, id: false do |t|
      t.string :asset_id
      t.string :media_type
      t.belongs_to :account
      t.string :title
      t.integer :duration
      t.string :location
      t.datetime :recorded_time
      t.string :timecode
      t.timestamps
    end
    execute 'ALTER TABLE media ADD PRIMARY KEY (asset_id);'
  end
end
