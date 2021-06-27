require 'rails_helper'

RSpec.describe WorkDay, type: :model do
  describe "relationships" do
    it { should belong_to(:project) }
    it { should belong_to(:day_of_week) }
  end
end
