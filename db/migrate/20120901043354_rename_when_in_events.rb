class RenameWhenInEvents < ActiveRecord::Migration
  def up
    rename_column :events, :when, :appointment
  end

  def down
    rename_column :events, :appointment, :when
  end
end
