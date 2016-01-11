class TagsController < ApplicationController
  def show
    string_tags = (params["tags"] || "").split(/[\s,+]+/)
    @tags = string_tags.map { |s| Tag.where(:name => s).first }.compact

    if @tags.count == 0
      redirect_to data_path
    else
      first = @tags.first
      @data = first.data.all.includes(:tags).order("created_at DESC")
      # TODO: Figure out if we can do a table join instead.
      @tags[1..-1].each { |t|
        @data = @data.select { |d| d.tags.include?(t) }
      }
      @grouped_data = group_by_day(@data)
    end
  end

private
  # Groups the data by date, and computes the average value per day
  def group_by_day(array)
    dmap = {}
    array.each { |d|
      sdate = d.created_at.strftime("%Y-%m-%d")
      dmap[sdate] = [] if dmap[sdate].nil?
      dmap[sdate] << d.value
    }

    dmap.keys.each { |date|
      avg = dmap[date].inject{ |sum, el| sum + el }.to_f / dmap[date].size
      dmap[date] = avg
    }
    return dmap
  end
end
