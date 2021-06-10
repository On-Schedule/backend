require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:name) }
  end

  describe "relationships" do
    it { should have_many(:users) }
  end
end
