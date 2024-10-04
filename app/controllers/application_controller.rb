class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_record

  def authenticate_user
    header = request.headers["Authorization"]

    return nil unless header

    token = header.split(" ")[1]

    begin
      payload = JWT.decode(token, Rails.application.credentials.secret_key_base)
      user_id = payload[0]["user_id"]
      @current_user = User.find(user_id)
    rescue JWT::DecodeError
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def not_found_record(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
