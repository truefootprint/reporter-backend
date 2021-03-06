class Activity < ApplicationRecord
  translates :name

  has_many :follow_up_activity_joins, class_name: :FollowUpActivity
  has_many :follow_up_activities, through: :follow_up_activity_joins

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
