require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:company_id)}
    it { should validate_presence_of(:hours_per_day) }
  end

  describe "relationships" do
    it { should belong_to(:company) }
  end
end
