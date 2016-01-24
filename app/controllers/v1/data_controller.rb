class V1::DataController < DataController
  protect_from_forgery with: :null_session

  # Skip before action from parent class, since those render HTML on failure.
  skip_before_action :require_login
  skip_before_action :require_ownership

  def index
    render_output_or_error(current_user, 401) do
      @data = Datum.where(:user_id => current_user.id).order("date DESC")
      render_json_output(@data)
    end
  end

  def show
    render_output_or_error(current_user && has_ownership_for_datum?(params[:id]), 401) do
      render_json_output(@datum)
    end
  end

  def create
    render_output_or_error(current_user, 401) do
      return unless parse_and_validate?(params)
      @datum_params[:user_id] = current_user.id
      @datum = Datum.create!(@datum_params)
      render_json_output(@datum)
    end
  end

  def update
    render_output_or_error(current_user && has_ownership_for_datum?(params[:id]), 401) do
      return unless parse_and_validate?(params)
      @datum.update!(@datum_params)
      render_json_output(@datum)
    end
  end

  def destroy
    render_output_or_error(current_user && has_ownership_for_datum?(params[:id]), 401) do
      @datum.destroy unless @datum.nil?
      render_json_output(@datum)
    end
  end

private
  def render_json_output(result)
    if params["pretty"] == "1"
      render json: JSON.pretty_generate(result.as_json)
    else
      render json: result
    end
  end

  def render_output_or_error(condition, error_status, error_msg = nil)
    default_error_messages = {
      401 => "Unauthorized!\n",
      403 => "Forbidden!\n",
    }

    if condition
      yield
    else
      render :text => (error_msg || default_error_messages[error_status]),
             :status => error_status
    end
  end

  def has_ownership_for_datum?(datum_id)
    @datum = Datum.find(datum_id)
    return @datum.user == current_user
  rescue
    false
  end
end
