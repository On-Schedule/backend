require 'rails_helper'

RSpec.describe "POST project endpoint" do
  before :each do
    DayOfWeek.create!(day: "Monday")
    DayOfWeek.create!(day: "Tuesday")
    DayOfWeek.create!(day: "Wednesday")
    DayOfWeek.create!(day: "Thursday")
    DayOfWeek.create!(day: "Friday")
    DayOfWeek.create!(day: "Saturday")
    DayOfWeek.create!(day: "Sunday")

    @company = Company.create!(name: "Rowan Electric")
    @user = User.create!( company_id: @company.id,
                  first_name: 'Doug',
                  last_name: 'Welchons',
                  email: "email@domain.com",
                  password: "another_password",
                  password_confirmation: "another_password",
                  api_key: "key" )
  end

  describe "Happy path" do
    it "returns a 201 response with a new project object" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:data])
      expect(body[:data]).to be_a(Hash)
      expect(body[:data].keys).to eq([:id, :type, :attributes])
      expect(body[:data][:id]).to eq("#{Project.last.id}")
      expect(body[:data][:type]).to eq("project")
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:start_date, :end_date, :name, :company_id, :hours_per_day])
      expect(body[:data][:attributes][:company_id]).to eq(@company.id)
      expect(body[:data][:attributes][:start_date]).to eq("2021-05-16")
      expect(body[:data][:attributes][:end_date]).to eq("2025-07-11")
      expect(body[:data][:attributes][:name]).to eq("Big Project")
      expect(body[:data][:attributes][:hours_per_day]).to eq(8)
    end
  end

  describe "Sad Path and Edge Case" do
    it "returns an error if all nessisry data is not provided"
    it "returns an error if user is not provided"
    it "returns an error if api_key is not provided"
    it "returns an unathorized error if user does not exist"
    it "returns an unathorized error if user and api key does not match"
  end
end
