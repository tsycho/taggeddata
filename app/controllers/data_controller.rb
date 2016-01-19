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
    # TODO: Validate params
    @tags = parse_tags_from_params
    value = params["datum"]["value"].to_f
    date = (params["datum"]["s_date"] && Date.parse(params["datum"]["s_date"])) || Date.today
    is_public = (params["datum"]["is_public"].to_i == 1)
    @datum = Datum.create(:user_id => current_user.id,
                          :value => value,
                          :is_public => is_public,
                          :date => date,
                          :tags => @tags)

    redirect_to data_path
  end

  def update
    # TODO: Validate params
    updated_values = {}
    updated_values[:tags] = parse_tags_from_params
    updated_values[:value] = params["datum"]["value"].to_f
    updated_values[:date] = (params["datum"]["s_date"] && Date.parse(params["datum"]["s_date"])) || Date.today
    updated_values[:is_public] = (params["datum"]["is_public"].to_i == 1)

    @datum.update(updated_values)
    redirect_to data_path
  end

  def destroy
    @datum.delete unless @datum.nil?
    redirect_to data_path
  end

private
  # Verifies that the datum referenced by params[:id] belongs to the current user.
  # Populates @datum if yes, redirects to a 500 page if not.
  def require_ownership
    @datum = Datum.find(params[:id])
    unless @datum.user == current_user
      render :file => "#{Rails.root}/public/500", :layout => false, :status => 500
    end
  end

  # Split, filter, format, dedupe and sort the tags
  def parse_tags_from_params
    s_tags = params["datum"]["tags"] || ""
    s_tags = "untagged" if s_tags.empty?
    return s_tags.split(/[\s,]+/)
              .map { |t| t[0]=='#' ? t[1..-1] : t }
              .map { |t| t.downcase}
              .select { |t| t.length > 0 }
              .uniq.sort
  end
end
