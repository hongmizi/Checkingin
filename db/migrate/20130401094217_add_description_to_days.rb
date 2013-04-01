class AddDescriptionToDays < ActiveRecord::Migration
  def change
    add_column :days, :description, :text
  end
end
