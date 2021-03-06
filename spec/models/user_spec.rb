require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
    it { should validate_presence_of(:api_key) }
    it { should validate_uniqueness_of(:api_key) }
  end

  describe "relationships" do
    it { should belong_to(:company) }
    it { should have_many(:project_users) }
    it { should have_many(:projects).through(:project_users) }
  end
end
