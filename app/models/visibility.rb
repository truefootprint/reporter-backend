class Visibility < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :visible_to, polymorphic: true

  validates :subject_id, uniqueness: {
    scope: %i[subject_type visible_to_type visible_to_id]
  }

  def self.subject_ids(subject_type)
    where(subject_type: subject_type.to_s).select(:subject_id)
  end

  def self.union(user: nil, role: nil, user_roles: nil)
    user_roles ||= UserRole.where(user: user, role: role) if user && role

    scope = none
    scope = scope.or(where(visible_to: user)) if user
    scope = scope.or(where(visible_to: role)) if role
    scope = scope.or(where(visible_to: user_roles)) if user_roles
    scope
  end
end
