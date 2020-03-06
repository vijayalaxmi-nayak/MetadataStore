# frozen_string_literal: true
class AddDefaultDuration < ActiveRecord::Migration[5.2]
  def change
    execute 'ALTER TABLE `media` ALTER `duration` SET DEFAULT 0;'
  end
end
