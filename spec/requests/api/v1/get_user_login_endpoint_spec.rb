require 'rails_helper'

RSpec.describe "GET user login endpoint" do
  describe "Happy path" do
    it "returns a 200 respons and user object if email and password are valid" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!(company_id: company.id,
                          first_name: 'Doug',
                          last_name: 'Welchons',
                          email: "email@domain.com",
                          password: "password",
                          password_confirmation: "password",
                          api_key: "key" )

      user_params = { email: "email@domain.com",
                      password: "password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users/login", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:data])
      expect(body[:data]).to be_a(Hash)
      expect(body[:data].keys).to eq([:id, :type, :attributes])
      expect(body[:data][:id]).to eq("#{user.id}")
      expect(body[:data][:type]).to eq("user")
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:company_id, :first_name, :last_name, :api_key])
      expect(body[:data][:attributes][:company_id]).to eq(company.id)
      expect(body[:data][:attributes][:first_name]).to eq("Doug")
      expect(body[:data][:attributes][:last_name]).to eq("Welchons")
      expect(body[:data][:attributes][:api_key]).to eq(user.api_key)
    end
  end

  describe "Sad path and Edge case" do
    it "returns a 400 invalid login error if a user doesn't exist" do
      company = Company.create!(name: "Rowan Electric")

      user_params = { email: "email@domain.com",
                      password: "password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users/login", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400) #propper code would be 404 but want to match bad api_key error
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("invalid login")
    end

    it "returns a 400 invalid login error if the email and password dont match" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!(company_id: company.id,
                          first_name: 'Doug',
                          last_name: 'Welchons',
                          email: "email@domain.com",
                          password: "password",
                          password_confirmation: "password",
                          api_key: "key" )

      user_params = { email: "email@domain.com",
                      password: "not_my_password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users/login", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("invalid login")
    end

    it "returns a 400 invalid login error if no password is provided" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!(company_id: company.id,
                          first_name: 'Doug',
                          last_name: 'Welchons',
                          email: "email@domain.com",
                          password: "password",
                          password_confirmation: "password",
                          api_key: "key" )

      user_params = { email: "email@domain.com"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users/login", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("invalid login")
    end

    it "returns a 400 invalid login error if no email is provided" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!(company_id: company.id,
                          first_name: 'Doug',
                          last_name: 'Welchons',
                          email: "email@domain.com",
                          password: "password",
                          password_confirmation: "password",
                          api_key: "key" )

      user_params = {password: "password"}

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/users/login", headers: headers, params: user_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("invalid login")
    end
  end
end
