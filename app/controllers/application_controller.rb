class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private
  def current_user
    return @current_user if @current_user

    # Find the user matching the id stored in the session.
    # If no such user exists, reset the session.
    @current_user = User.where(:id => session[:user_id]).first
    if @current_user
      return @current_user
    else
      session[:user_id] = nil
    end
  end
  # Make :current_user a helper method so that views can access it easily.
  helper_method :current_user

  def require_login
    unless current_user
      redirect_to signin_path, :notice => "Please sign in."
    end
  end
end
