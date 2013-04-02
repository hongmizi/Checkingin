class RemoveUserIdFromMemberships < ActiveRecord::Migration
  def up
    remove_column :memberships, :user_id
  end

  def down
    add_column :memberships, :user_id, :integer
  end
end
