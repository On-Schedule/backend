require 'rails_helper'

RSpec.describe DayOfWeek, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:day) }
  end

  describe "relationships" do
    it { should have_many(:work_days) }
    it { should have_many(:projects).through(:work_days) }
  end
end
