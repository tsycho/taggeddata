class TagsController < ApplicationController
  def show
    @tags = (params["tags"] || "")
              .split(/[\s,]+/)
              .map { |t| t[0]=='#' ? t[1..-1] : t }
              .map { |t| t.downcase }
              .select { |t| t.length > 0 }

    if @tags.count == 0
      redirect_to data_path
    else
      @data = Datum.all_tags(@tags).order("date DESC")
      # @grouped_data = Datum.all_tags(@tags).group_by_day(:date).average(:value)
      # ActiveRecord::Base.connection.execute("SELECT date, avg(value) AS average_value from data WHERE tags @> [#{@tags.map {|t| '\''+t+'\''}.join('')}] GROUP BY date")
      @grouped_data = group_by_day(@data)
    end
  end

private
  # Groups the data by date, and computes the average value per day
  def group_by_day(array)
    dmap = {}
    array.each { |d|
      sdate = d.date.strftime("%Y-%m-%d")
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
