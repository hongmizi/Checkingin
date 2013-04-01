class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
      t.string :state, :null => false, :default => "pending"

      t.timestamps
    end
  end
end
