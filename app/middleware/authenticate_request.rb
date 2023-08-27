# app/middleware/authenticate_request.rb

class AuthenticateRequest
    def initialize(app)
      @app = app
    end
  
    def call(env)
      @env = env
      if authenticated?
        @app.call(env)
      else
        unauthorized_response
      end
    end
  
    private
  
    def authenticated?
      user.present?
    end
  
    def user
      @user ||= User.find_by(id: decoded_token['user_id']) if decoded_token
    end
  
    def decoded_token
      JsonWebToken.decode(http_auth_header)
    end
  
    def http_auth_header
      if headers['Authorization'].present?
        headers['Authorization'].split(' ').last
      end
    end
  
    def headers
      @env.fetch('headers', {})
    end
  
    def unauthorized_response
      [401, { 'Content-Type' => 'application/json' }, [{ error: 'Unauthorized' }.to_json]]
    end
  end
  