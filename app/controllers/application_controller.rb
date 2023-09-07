# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
    before_action :authorized
    before_action :authorize_admin_or_teacher
    attr_reader :current_user
    SECRET_KEY = Rails.application.secrets.secret_key_base
    ALGORITHM = 'HS256'.freeze
  
    def encode_token(payload, expiration = 15.minutes.from_now)
      payload[:exp] = expiration.to_i
      JWT.encode(payload, SECRET_KEY, ALGORITHM)
    end
  
    def auth_header
      request.headers['Authorization']
    end
  
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, SECRET_KEY, true, algorithm:ALGORITHM)
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    def current_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @current_user = User.find_by(id: user_id)
      end
    end
  
    def logged_in?
      !!current_user
    end
  
    def authorized
      render json: { error: 'Unauthorized' }, status: :unauthorized unless logged_in?
    end
  
    def refresh_token(payload)
      token = encode_token(payload)
      refresh_token = JWT.encode(payload.merge({ exp: 1.week.from_now.to_i }), SECRET_KEY)
      { token: token, refresh_token: refresh_token }
    end

    def authorize_admin_or_teacher
      
      return if current_user && (current_user["role"].downcase == "admin" || current_user["role"].downcase == "teacher")
  
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  