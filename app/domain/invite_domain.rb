class InviteDomain
  def self.approved_invite invite_id
    invite = Invite.find(invite_id)
    return unless Membership.where(:user_id => invite.invited_user_id, :project_id => invite.project_id).blank?
    return  Membership.create!(:user_id => invite.invited_user_id, :project_id => invite.project_id)
  end
end
