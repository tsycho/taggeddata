class TagsController < ApplicationController
  def show
    @tag = Tag.where(:name => params["name"]).first
    @data = @tag.data.all if @tag else []
  end
end
