class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  respond_to :json
  
  private
  
  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def authenticate_user!
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ').last
        decoded = JWT.decode(token, ENV['DEVISE_JWT_SECRET_KEY']).first
        @current_user = User.find(decoded['sub'])
      rescue JWT::ExpiredSignature
        render json: { error: 'Token has expired' }, status: :unauthorized
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end 