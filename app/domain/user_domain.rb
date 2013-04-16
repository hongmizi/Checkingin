class UserDomain
  def self.get_user_name id
    user = User.find(id)
    return unless user
    if user.nickname != nil and user.nickname != ""
      return user.nickname
    else
      return user.email
    end
  end
end
