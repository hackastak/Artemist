class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :reported_bugs, class_name: "Bug", foreign_key: :reporter_id, dependent: :nullify
  has_many :assigned_bugs, class_name: "Bug", foreign_key: :assignee_id, dependent: :nullify
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
end
