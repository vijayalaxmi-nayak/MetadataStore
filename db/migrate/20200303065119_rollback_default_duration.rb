# frozen_string_literal: true
class RollbackDefaultDuration < ActiveRecord::Migration[5.2]
  def up
    change_column_default(:media, :duration, 0)
  end

  def down
    change_column_default(:media, :duration, nil)
  end
end
