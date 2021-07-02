module ErrorHandling
  def invalid_record(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def unauthorized_request
    render json: { error: "unauthorized" }, status: :unauthorized
  end

  def invalid_login
    render json: { error: "invalid login" }, status: :bad_request
  end

  def days_required
    render json: { error: "At least 1 working day must me selected" }, status: :bad_request
  end
end
