class Project < ApplicationRecord
  belongs_to :company

  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :name
  validates :name, uniqueness: { scope: :company_id }
  validates_presence_of :hours_per_day
  validates_numericality_of :hours_per_day
end
