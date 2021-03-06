require 'rails_helper'

RSpec.describe "POST project endpoint" do
  before :each do
    @sunday = DayOfWeek.create!(day: "Sunday")
    @monday = DayOfWeek.create!(day: "Monday")
    @tuesday = DayOfWeek.create!(day: "Tuesday")
    @wednesday = DayOfWeek.create!(day: "Wednesday")
    @thursday = DayOfWeek.create!(day: "Thursday")
    @friday = DayOfWeek.create!(day: "Friday")
    @saturday = DayOfWeek.create!(day: "Saturday")

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
      expect(body[:data][:attributes].keys).to eq([:start_date, :end_date, :name, :company_id, :hours_per_day, :work_days])
      expect(body[:data][:attributes][:company_id]).to eq(@company.id)
      expect(body[:data][:attributes][:start_date]).to eq("2021-05-16")
      expect(body[:data][:attributes][:end_date]).to eq("2025-07-11")
      expect(body[:data][:attributes][:name]).to eq("Big Project")
      expect(body[:data][:attributes][:hours_per_day]).to eq(8)
      expect(body[:data][:attributes][:work_days]).to be_a(Array)
      expect(body[:data][:attributes][:work_days].count).to eq(5)
      expect(body[:data][:attributes][:work_days][0][:project_id]).to eq(Project.last.id)
      expect(body[:data][:attributes][:work_days][0][:day_of_week_id]).to eq(@monday.id)
      expect(body[:data][:attributes][:work_days][1][:project_id]).to eq(Project.last.id)
      expect(body[:data][:attributes][:work_days][1][:day_of_week_id]).to eq(@tuesday.id)
      expect(body[:data][:attributes][:work_days][2][:project_id]).to eq(Project.last.id)
      expect(body[:data][:attributes][:work_days][2][:day_of_week_id]).to eq(@wednesday.id)
      expect(body[:data][:attributes][:work_days][3][:project_id]).to eq(Project.last.id)
      expect(body[:data][:attributes][:work_days][3][:day_of_week_id]).to eq(@thursday.id)
      expect(body[:data][:attributes][:work_days][4][:project_id]).to eq(Project.last.id)
      expect(body[:data][:attributes][:work_days][4][:day_of_week_id]).to eq(@friday.id)
    end
  end

  describe "Sad Path and Edge Case" do
    it "returns a 201 response with a new project object ignoring repeated days of the week" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Tuesday", "Tuesday", "Tuesday"]
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
      expect(body[:data][:attributes].keys).to eq([:start_date, :end_date, :name, :company_id, :hours_per_day, :work_days])
      expect(body[:data][:attributes][:company_id]).to eq(@company.id)
      expect(body[:data][:attributes][:start_date]).to eq("2021-05-16")
      expect(body[:data][:attributes][:end_date]).to eq("2025-07-11")
      expect(body[:data][:attributes][:name]).to eq("Big Project")
      expect(body[:data][:attributes][:hours_per_day]).to eq(8)
      expect(body[:data][:attributes][:work_days]).to be_a(Array)
      expect(body[:data][:attributes][:work_days].count).to eq(1)
      expect(body[:data][:attributes][:work_days][0][:project_id]).to eq(Project.last.id)
      expect(body[:data][:attributes][:work_days][0][:day_of_week_id]).to eq(@tuesday.id)
    end

    it "returns a 400 error if days of week is not provided" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("At least 1 working day must me selected")
    end

    it "returns a 400 error if days of week is empty" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: []
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("At least 1 working day must me selected")
    end

    it "returns a 400 error if days of week includes invalid days of the week" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["not a day of the week", "Tuesday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("At least 1 working day must me selected") #I dont like this error, need to revisit
    end

    it "returns a 400 error if hours per day is lees then 1" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 0,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Hours per day must be greater than 0")
    end

    it "returns a 400 error if hours per day is greater then 24" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 25,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Hours per day must be less than or equal to 24")
    end

    it "returns a 400 error if hours per day is blank" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: "",
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Hours per day can't be blank, Hours per day is not a number")
    end

    it "returns a 400 error if hours per day is not a integer" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: "not a number",
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Hours per day is not a number")
    end

    it "returns a 400 error if start date is not provided" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Start date can't be blank")
    end

    it "returns a 400 error if start date is blank" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: "",
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Start date can't be blank")
    end

    xit "returns a 400 error if start date is not a date" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: "not a date",
                          end_date: Date.new(2025, 7, 11),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: Start date can't be blank")
    end

    it "returns a 400 error if end date is not provided" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: End date can't be blank")
    end

    it "returns a 400 error if end date is blank" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: "",
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: End date can't be blank")
    end

    xit "returns a 400 error if end date is not a date" do
      project_params = { user_id: @user.id,
                          api_key: @user.api_key,
                          start_date: Date.new(2021, 5, 16),
                          end_date: "Not a date",
                          name: "Big Project",
                          hours_per_day: 8,
                          days_of_week: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                        }

      headers = {"CONTENT_TYPE" => "application/json",
                 "ACCEPT"       => "application/json"}

      post "/api/v1/projects", headers: headers, params: project_params.to_json

      body = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(response.status).to eq(400)
      expect(response.content_type).to eq("application/json")
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:error])
      expect(body[:error]).to eq("Validation failed: End date can't be blank")
    end

    describe "Unauthorized Errors" do
      it "returns a 401 unauthorized error if a user doesn't exist" do
        project_params = { user_id: (@user.id + 1),
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

        expect(response).to_not be_successful
        expect(response.status).to eq(401)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:error])
        expect(body[:error]).to eq("unauthorized")
      end

      it "returns a 401 unauthorized error if the api_key and user id dont match" do
        project_params = { user_id: @user.id,
                            api_key: "not my key",
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

        expect(response).to_not be_successful
        expect(response.status).to eq(401)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:error])
        expect(body[:error]).to eq("unauthorized")
      end

      it "returns a 401 unauthorized error if user is not provided" do
        project_params = { api_key: @user.api_key,
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

        expect(response).to_not be_successful
        expect(response.status).to eq(401)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:error])
        expect(body[:error]).to eq("unauthorized")
      end

      it "returns a 401 unauthorized error if api_key is not provided" do
        project_params = { user_id: @user.id,
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

        expect(response).to_not be_successful
        expect(response.status).to eq(401)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:error])
        expect(body[:error]).to eq("unauthorized")
      end

      it "returns only a 401 unauthorized error and not a 400 bad request error if both are valid" do
        project_params = { user_id: @user.id,
                            api_key: "not my key",
                            start_date: Date.new(2021, 5, 16),
                            end_date: Date.new(2025, 7, 11),
                            name: "Big Project",
                            hours_per_day: 8,
                          }

        headers = {"CONTENT_TYPE" => "application/json",
                   "ACCEPT"       => "application/json"}

        post "/api/v1/projects", headers: headers, params: project_params.to_json

        body = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(401)
        expect(body).to be_a(Hash)
        expect(body.keys).to eq([:error])
        expect(body[:error]).to eq("unauthorized")
      end
    end
  end
end
