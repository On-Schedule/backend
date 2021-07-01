require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:company_id)}
    it { should validate_presence_of(:hours_per_day) }
    it { should validate_numericality_of(:hours_per_day).is_greater_than(0) }
    it { should validate_numericality_of(:hours_per_day).is_less_than(25) }
  end

  describe "relationships" do
    it { should belong_to(:company) }
    it { should have_many(:project_users) }
    it { should have_many(:users).through(:project_users) }
    it { should have_many(:work_days) }
    it { should have_many(:day_of_weeks).through(:work_days) }
  end
end
