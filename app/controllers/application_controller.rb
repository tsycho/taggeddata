class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

private

  def current_user
    return @current_user if @current_user

    if params[:key]
      api_key = ApiKey.where(:key => params[:key]).first
      @current_user = User.find(api_key.user_id) if api_key
      return @current_user if @current_user
    end

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

  # Split, filter, format, dedupe and sort the tags
  def parse_tags(string_tags)
    s_tags = string_tags || ""
    s_tags = "untagged" if s_tags.empty?
    return s_tags.split(/[\s,]+/)
              .map { |t| t[0]=='#' ? t[1..-1] : t }
              .map { |t| t.downcase}
              .select { |t| t.length > 0 }
              .uniq.sort
  end
end
