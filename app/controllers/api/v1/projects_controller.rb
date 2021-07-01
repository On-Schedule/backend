class Api::V1::ProjectsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    if valid_user?(user)
      project = Project.new(project_params)
      project.company_id = user.company_id
      if project.save!
        DayOfWeek.all.each do |day|
          WorkDay.create!(project: project, day_of_week: day) if params[:days_of_week].include?(day.day)
        end
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
