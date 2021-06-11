require 'rails_helper'

RSpec.describe "GET user endpoint" do
  describe "Happy path" do
    it "returns a user if a user id and valid api_key are provided" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!( company_id: company.id,
                    first_name: 'Doug',
                    last_name: 'Welchons',
                    email: "email@domain.com",
                    password: "another_password",
                    password_confirmation: "another_password",
                    api_key: "key" )

      get "/api/v1/users/#{user.id}?api_key=#{user.api_key}"

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
    it "returns an unauthorized error if a user doesn't exist" do
      get "/api/v1/users/1?api_key=123456789"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401) #propper code would be 404 but want to match bad api_key error
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("unauthorized")
    end

    it "returns an unauthorized error if the api_key and user id dont match" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!( company_id: company.id,
                    first_name: 'Doug',
                    last_name: 'Welchons',
                    email: "email@domain.com",
                    password: "another_password",
                    password_confirmation: "another_password",
                    api_key: "key" )

      get "/api/v1/users/#{user.id}?api_key=not_correct_key"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("unauthorized")
    end

    it "returns an unauthorized error if no api_key is provided" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!( company_id: company.id,
                    first_name: 'Doug',
                    last_name: 'Welchons',
                    email: "email@domain.com",
                    password: "another_password",
                    password_confirmation: "another_password",
                    api_key: "key" )

      get "/api/v1/users/#{user.id}"

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("unauthorized")
    end

    it "returns an unauthorized error if api_key is blank" do
      company = Company.create!(name: "Rowan Electric")

      user = User.create!( company_id: company.id,
                    first_name: 'Doug',
                    last_name: 'Welchons',
                    email: "email@domain.com",
                    password: "another_password",
                    password_confirmation: "another_password",
                    api_key: "key" )

      get "/api/v1/users/#{user.id}?api_key="

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(401)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("unauthorized")
    end
  end
end
