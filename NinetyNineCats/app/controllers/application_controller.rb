class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception

    def current_user
      #session is a hash built into rails,
      return nil unless session[:session_token]
      @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def logged_in?
      !!current_user
    end

    def login!(user)
      user.reset_session_token!
      session[:session_token] = user.session_token
    end

    def logout!
      current_user.reset_session_token!
      session[:session_token] = nil
    end

    def require_logged_in
      redirect_to new_session_url unless logged_in?
    end

    def require_logged_out
      redirect_to cats_url if logged_in?
    end

end
