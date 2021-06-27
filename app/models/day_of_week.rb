class DayOfWeek < ApplicationRecord
  has_many :work_days
  has_many :projects, through: :work_days

  validates_presence_of :day
end
