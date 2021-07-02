class Api::V1::UsersController < ApplicationController
  def show
    user = User.find(params[:id])
    if valid_user?(user)
      render json: UserSerializer.new(user), status: :ok
    else
      unauthorized_request
    end
  end

  def login
    user = nil
    user = User.find_by(email: params[:email].downcase) if params[:email]
    if user && user.authenticate(params[:password])
      render json: UserSerializer.new(user), status: :ok
    else
      invalid_login
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

  def valid_user?(user)
    user.api_key == params[:api_key]
  end
end
