# app/controllers/users_controller.rb

class UsersController < ApplicationController
    skip_before_action :authorized, only: [:register, :login]
  
    def register
      user = User.create(user_params)
      if user.valid?
        access_token = encode_token(user_id: user.id)
        refresh_token = encode_token({ user_id: user.id, refresh: true }, 1.week.from_now)
        render json: {
            user: {
              id: user.id,
              username: user.username,
              email: user.email
            },
            access_token: access_token,
            refresh_token: refresh_token
          }, status: :created
      else
        render json: { error: "Invalid user details" }, status: :unprocessable_entity
      end
    end
  
    def login
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        access_token = encode_token(user_id: user.id)
        refresh_token = AuthenticationService.encode({ user_id: user.id, refresh: true }, 1.week.from_now)
        render json: {
            user: {
              id: user.id,
              username: user.username,
              email: user.email
            },
            access_token: access_token,
            refresh_token: refresh_token
          }, status: :created
      else
        render json: { error: "Invalid username or password" }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.permit(:username, :email, :password, :role)
    end
  end
  