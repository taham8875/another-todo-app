class AuthController < ApplicationController
  def signup
    user = User.new(signup_params)

    if user.save
      token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
      render json: {
        user: UserSerializer.new(user),
        token: token
      }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: login_params[:email])

    if user && user.authenticate(login_params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)

      render json: {
        user: UserSerializer.new(user),
        token: token
      }
    else
      render json: { errors: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def signup_params
    params.permit(:name, :email, :username, :password)
  end

  def login_params
    params.permit(:email, :password)
  end
end
