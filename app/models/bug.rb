class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :reporter, class_name: "User"
  belongs_to :assignee, class_name: "User", optional: true
  has_many :comments, dependent: :destroy

  enum :status, { open: 0, in_progress: 1, resolved: 2, closed: 3 }
  enum :priority, { low: 0, medium: 1, high: 2, critical: 3 }

  validates :title, presence: true
  validates :status, presence: true
  validates :priority, presence: true

  scope :by_status, ->(status) { where(status: status) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :assigned_to, ->(user) { where(assignee: user) }
  scope :reported_by, ->(user) { where(reporter: user) }
end
