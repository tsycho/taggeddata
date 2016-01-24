class DataController < ApplicationController
  before_action :require_login, :except => :index
  before_action :require_ownership, :only => [:edit, :update, :destroy]

  def index
    if current_user
      @data = Datum.where("user_id = #{current_user.id} OR is_public = 't'").order("date DESC")
    else
      @data = Datum.where(:is_public => true).order("date DESC")
    end
  end

  def new
    @title = "Add new data"
    @datum = Datum.new(:date => Date.today)
  end

  def edit
    @title = "Edit data"
  end

  def create
    return unless parse_and_validate?(params)
    @datum_params[:user_id] = current_user.id
    @datum = Datum.create!(@datum_params)
    redirect_to data_path
  end

  def update
    return unless parse_and_validate?(params)
    @datum.update!(@datum_params)
    redirect_to data_path
  end

  def destroy
    @datum.destroy unless @datum.nil?
    redirect_to data_path
  end

private
  # TODO: Move to Datum.rb?
  # Parses and validates all params relevant to a datum.
  # Fills @tags, @jsondata, @date, @is_public and optionally @value on success, and returns true.
  # Fills @error, renders a 400 and returns false on invalid params.
  def parse_and_validate?(params)
    dparams = params["datum"]
    unless dparams
      render :text => "Invalid params: #{params}", :status => 400
      return false
    end

    @date = parse_date(dparams["date"]) if dparams["date"]
    @tags = parse_tags(dparams["tags"]) if dparams["tags"]

    if dparams["value"] && dparams["value"].strip != ""
      @value = dparams["value"].strip.to_f
    end

    s_data = dparams["data"]
    begin
      @jsondata = JSON.parse(s_data) if s_data && s_data.strip != ""
    rescue
      @error = "Unable to parse data JSON : #{s_data}\n"
    end

    @is_public = (dparams["is_public"].to_i == 1) if dparams["is_public"]
    puts "@is_public = #{@is_public}"
    puts dparams["is_public"]
    puts (dparams["is_public"].to_i == 1)

    if @error
      # No-op; break if there is already an error
    elsif @value.nil? && @jsondata.nil? && !request.patch?
      @error = "Please set atleast ONE of 'value' or 'data'."
    elsif @tags.nil? && dparams["tags"]
      @error = "Error while parsing tags from: #{dparams["tags"]}"
    elsif @date.nil? && dparams["date"]
      @error = "Error while parsing date from: #{dparams["date"]}"
    end

    if @error
      render :text => @error, :status => 400
      return false
    end

    # If the request is of type POST or PUT, set default values.
    if request.post? or request.put?
      @date = Date.today if @date.nil?
      @tags = ["untagged"] if @tags.nil?
      @is_public = false if @is_public.nil?
      if @jsondata.nil?
        @jsondata = !@value.nil? ? { value: @value } : {}
      end
      @value = 0.0 if @value.nil?
    end

    @datum_params = {}
    @datum_params[:value] = @value unless @value.nil?
    @datum_params[:data] = @jsondata unless @jsondata.nil?
    @datum_params[:date] = @date unless @date.nil?
    @datum_params[:tags] = @tags unless @tags.nil?
    @datum_params[:is_public] = @is_public unless @is_public.nil?

    return true
  end

  def parse_date(string_date)
    return Date.today if (!string_date || string_date.strip == "")
    return Date.parse(string_date) rescue nil
  end

  # Verifies that the datum referenced by params[:id] belongs to the current user.
  # Populates @datum if yes, redirects to a 500 page if not.
  def require_ownership
    @datum = Datum.find(params[:id])
    unless @datum.user == current_user
      render :file => "#{Rails.root}/public/500", :layout => false, :status => 500
    end
  end
end
