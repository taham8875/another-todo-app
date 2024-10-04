class ApplicationController < ActionController::API
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
end
