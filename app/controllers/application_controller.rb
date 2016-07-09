class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def admin_only
    unless current_user && current_user.admin
      redirect_back fallback_location: '/', alert: 'Access denied.'
    end
  end
end
