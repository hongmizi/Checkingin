class ProjectDomain
 @@users = {}
  def self.get_user_joined_project user
     init if @@users.blank?
     return @@users[user]
  end

  def self.add_user_to_project user, project
    if @@users.blank?
      init
    else
      @@users[user] << project
    end
  end

  def self.remove_user_from_project user, project
    if @@users.blank?
      init
    else
      @@users[user].delete project
    end
  end
private
  def self.init
    User.all.each do |user|
      @@users[user] = Project.select { |p| p.users.include? user }
    end
  end
end
