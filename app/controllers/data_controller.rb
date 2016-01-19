class DataController < ApplicationController
  before_action :require_login, :except => :index

  def index
    if current_user
      @data = Datum.where(:user => current_user).order("date DESC")
    else
      # TODO: Show only public data, not all.
      @data = Datum.all.order("date DESC")
    end
  end

  def new
    @title = "Add new data"
    @datum = Datum.new
    @tags = []
  end

  def edit
    @title = "Edit data"
  end

  def create
    # TODO: Validate params

    # Split, filter and format the tags
    # TODO: Dedupe tags?
    s_tags = params["datum"]["tags"] || ""
    s_tags = "untagged" if s_tags.empty?
    @tags = s_tags.split(/[\s,]+/)
              .map { |t| t[0]=='#' ? t[1..-1] : t }
              .map { |t| t.downcase}
              .select { |t| t.length > 0 }

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

  def destroy
    d = Datum.find(params[:id])
    d.delete if !d.nil?
    redirect_to data_path
  end
end
