class DefaultExpectedValue < ApplicationRecord
  belongs_to :question
  belongs_to :activity, optional: true

  validates :value, presence: true

  def self.for(question:, activity: nil)
    record  = find_by(question: question, activity: activity) if activity
    record || find_by(question: question)
  end
end