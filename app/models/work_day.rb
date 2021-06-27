class WorkDay < ApplicationRecord
  belongs_to :project
  belongs_to :day_of_week
end
