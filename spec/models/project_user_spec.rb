require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  describe "validations" do
    it { should validate_presence_of(:user_level) }
    it { should define_enum_for(:user_level).with_values([:admin]) }
  end

  describe "relationships" do
    it { should belong_to(:project) }
    it { should belong_to(:user) }
  end
end
