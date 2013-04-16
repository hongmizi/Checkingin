class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :invited_user_id
      t.string :message
      t.string :state
      t.string :token

      t.timestamps
    end
  end
end
