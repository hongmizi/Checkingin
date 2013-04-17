class InviteDomain
  def self.approved_invite invite
    unless Membership.where(:user_id => invite.invited_user_id, :project_id => invite.project_id)
      return false
    end
    return  Membership.create!(:user_id => invite.invited_user_id, :project_id => invite.project_id)
  end
end
