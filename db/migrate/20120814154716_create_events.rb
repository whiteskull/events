class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.text :name
      t.datetime :when
      t.integer :next_time

      t.timestamps
    end
  end
end
