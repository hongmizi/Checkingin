class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.datetime :apply_for
      t.datetime :approval
      t.string :statu

      t.timestamps
    end
  end
end
