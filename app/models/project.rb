class Project < ApplicationRecord
  belongs_to :user
  has_many :bugs, dependent: :destroy

  validates :name, presence: true
end
