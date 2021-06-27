require 'rails_helper'

RSpec.describe DayOfWeek, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:day) }
  end
end
