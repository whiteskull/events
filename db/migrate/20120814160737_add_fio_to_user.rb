class AddFioToUser < ActiveRecord::Migration
  def change
    add_column :users, :fio, :text
  end
end
