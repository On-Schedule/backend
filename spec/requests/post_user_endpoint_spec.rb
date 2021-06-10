require 'rails_helper'

RSpec.describe "POST user endpoint" do
  describe "Happy Path" do
    it "returns a new user object if all required params are provided" do
      company = Company.create!(name: "Rowan Electric")
      user_params = { company_id: company.id,
                      first_name: 'Doug',
                      last_name: 'Welchons',
                      email: "email@domain.com",
                      password: "password",
                      password_confirmation: "password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:data])
      expect(body[:data]).to be_a(Hash)
      expect(body[:data].keys).to eq([:id, :type, :attributes])
      expect(body[:data][:id]).to eq("#{User.last.id}")
      expect(body[:data][:type]).to eq("user")
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:company_id, :first_name, :last_name, :api_key])
      expect(body[:data][:attributes][:company_id]).to eq(company.id)
      expect(body[:data][:attributes][:first_name]).to eq("Doug")
      expect(body[:data][:attributes][:last_name]).to eq("Welchons")
      expect(body[:data][:attributes][:api_key]).to eq(User.last.api_key)
    end
  end

  describe "Sad path and Edge case" do
    it "returns an error if the request body is not provided" do
      post "/api/v1/users"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Company must exist, First name can't be blank, Last name can't be blank, Email can't be blank, Email is invalid, Password can't be blank, Password can't be blank, Password confirmation can't be blank")
    end

    it "returns an error if the password and confirmation don't match" do
      company = Company.create!(name: "Rowan Electric")
      user_params = { company_id: company.id,
                      first_name: 'Doug',
                      last_name: 'Welchons',
                      email: "email@domain.com",
                      password: "password",
                      password_confirmation: "not_password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Password confirmation doesn't match Password")
    end

    it "returns an error if the email is in an invalid format" do
      company = Company.create!(name: "Rowan Electric")
      user_params = { company_id: company.id,
                      first_name: 'Doug',
                      last_name: 'Welchons',
                      email: "emaildomain.com",
                      password: "password",
                      password_confirmation: "password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Email is invalid")
    end

    it "returns an error if email is not unique" do
      company = Company.create!(name: "Rowan Electric")

      User.create!( company_id: company.id,
                    first_name: 'Sam',
                    last_name: 'Something',
                    email: "email@domain.com",
                    password: "another_password",
                    password_confirmation: "another_password",
                    api_key: "key" )

      user_params = { company_id: company.id,
                      first_name: 'Doug',
                      last_name: 'Welchons',
                      email: "email@domain.com",
                      password: "password",
                      password_confirmation: "password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Email has already been taken")
    end
  end
end
