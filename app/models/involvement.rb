class Involvement < ApplicationRecord
  belongs_to :project_activity
  belongs_to :user

  scope :for_role, -> (role) do
    user_roles = UserRole.where(role: role)

    visibilities = Visibility.where(visible_to: user_roles)
    projects = visibilities.subject_ids(Project)
    project_activities = visibilities.subject_ids(ProjectActivity)

    involvements = includes(project_activity: :project)
      .where(user: user_roles.select(:user_id))

    scope1 = involvements.where(project_activity_id: project_activities)
    scope2 = involvements.where(project_activities: { project_id: projects })

    scope1.or(scope2)
  end

  def self.find_by_role!(role)
    scope = for_role(role)
    count = scope.count

    raise ActiveRecord::RecordNotFound, "Couldn't find involvement for role '#{role.name}'" if count.zero?
    raise AmbiguousInvolvementError, "More than one involvement for role '#{role.name}'" if count > 1

    scope.first
  end

  class ::AmbiguousInvolvementError < StandardError; end
end
