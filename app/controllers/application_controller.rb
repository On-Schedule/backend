class ApplicationController < ActionController::API
  include ErrorHandling
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_request
end
