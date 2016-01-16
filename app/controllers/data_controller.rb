class DataController < ApplicationController
  def index
    @data = Datum.all.order("date DESC")
  end

  def new
    @datum = Datum.new
    @tags = []
  end

  def create
    # TODO: Validate params

    # Split, filter and format the tags
    # TODO: Dedupe tags?
    s_tags = params["datum"]["s_tags"] || ""
    s_tags = "untagged" if s_tags.empty?
    @tags = s_tags.split(/[\s,]+/)
              .map { |t| t[0]=='#' ? t[1..-1] : t }
              .map { |t| t.downcase}
              .select { |t| t.length > 0 }

    value = params["datum"]["value"].to_f
    date = (params["datum"]["s_date"] && Date.parse(params["datum"]["s_date"])) || Date.today
    @datum = Datum.create(:value => value, :date => date, :tags => @tags)

    redirect_to data_path
  end

  def destroy
    d = Datum.find(params[:id])
    d.delete if !d.nil?
    redirect_to data_path
  end

private

  def datum_params
    params.require(:datum).permit(:value)
  end
end
