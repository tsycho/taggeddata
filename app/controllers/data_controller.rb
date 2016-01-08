class DataController < ApplicationController
  def index
    @data = Datum.all
  end

  def new
    @datum = Datum.new
    @tags = []
  end

  def create
    # TODO: Validate that there is some value

    value = params["datum"]["value"].to_f
    @datum = Datum.create(:value => value)

    # Find the tag objects for each string tag, create if necessary
    string_tags = params["datum"]["string_tags"] || ""
    string_tags = "untagged" if string_tags.empty?
    @tags = []
    string_tags.split(/[\s,]+/).each do |string_tag|
      # TODO: Figure out if Rails has a upsert command
      string_tag = string_tag.downcase
      tag = Tag.where(:name => string_tag).first
      if !tag
        tag = Tag.create(:name => string_tag)
      end

      # Add the [data, tag] association to the join table.
      @datum.tags << tag
    end

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
