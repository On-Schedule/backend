class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_request

  def show
    user = User.find(params[:id])
    if user.api_key == params[:api_key]
      render json: UserSerializer.new(user), status: :ok
    else
      unauthorized_request
    end
  end

  def create
    user = User.new(user_params)
    user.api_key = SecureRandom.hex(20)
    user.save!
    render json: UserSerializer.new(user), status: :created
  end

  private

  def user_params
    params.permit(:company_id, :first_name, :last_name, :email.downcase, :password, :password_confirmation)
  end

  def invalid_record(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def unauthorized_request
    render json: { error: "unauthorized" }, status: :unauthorized
  end
end
