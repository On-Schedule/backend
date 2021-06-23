class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates_presence_of :user_level

  enum user_level: [:admin]
end
