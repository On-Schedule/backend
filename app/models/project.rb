class Project < ApplicationRecord
  belongs_to :company
  has_many :project_users
  has_many :users, through: :project_users
  has_many :work_days
  has_many :day_of_weeks, through: :work_days

  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :name
  validates :name, uniqueness: { scope: :company_id }
  validates :hours_per_day, presence: true, numericality: {
            greater_than: 0,
            less_than: 25
          }

  # validates :renter_id, presence: true, numericality: {
  #         greater_than_or_equal_to: 0
  #       }
end
