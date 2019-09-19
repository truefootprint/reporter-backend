class ProjectActivity < ApplicationRecord
  belongs_to :project
  belongs_to :activity
  has_many :project_questions, as: :subject, inverse_of: :subject

  delegate :name, to: :activity

  scope :visible, -> { visible_to(Viewpoint.current) }

  scope :visible_to, -> (viewpoint) {
    viewpoint.scope(self).or(where(activity_id: Activity.visible_to(viewpoint)))
  }

  scope :with_visible_project_questions, -> (viewpoint) {
    joins(:project_questions).merge(ProjectQuestion.visible_to(viewpoint))
  }

  validates :order, presence: true
end
