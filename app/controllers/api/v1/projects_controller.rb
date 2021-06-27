class Api::V1::ProjectsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    if valid_user?(user)
      project = Project.new(project_params)
      project.company_id = user.company_id
      #create WorkDays based off of days_of_week
      if project.save!
        render json: ProjectSerializer.new(project), status: :created

      end
    end
  end

  private
  def project_params
    params.permit(:start_date, :end_date, :name, :hours_per_day)
  end

  def valid_user?(user)
    user.api_key == params[:api_key]
  end
end
