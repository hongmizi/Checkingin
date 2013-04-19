class ProjectDomain
  @@users_projects = {}

  def self.get_user_joined_projects user_id
    init if @@users_projects.blank?
    return @@users_projects[user_id]
  end

  def self.add_user_to_projects user_id, project_id
    if @@users_projects.blank?
      init
    else
      @@users_projects[user_id] << project_id unless @@users_projects[user_id].include? project_id
    end
  end

  def self.remove_user_from_projects user_id, project_id
    init if @@users_projects.blank?
    @@users_projects[user_id].delete project_id
  end
  private
  def self.init
    User.all.each do |user|
      Project.all.each do |p|
        @@users_projects[user.id] = [] if @@users_projects[user.id] == nil
        @@users_projects[user.id] <<  p.id if p.users.include? user
      end
    end
  end
end
