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

      # Average and group by date via direct SQL
      results = ActiveRecord::Base.connection.execute("SELECT date, avg(value) AS average_value from data WHERE tags @> ARRAY[#{@tags.map {|t| '\''+t+'\''}.join(',')}] GROUP BY date")
      @grouped_data = {}
      results.each { |row| @grouped_data[row["date"]] = row["average_value"].to_f }

      # Compute grouped average in Ruby
      # @grouped_data = group_by_day(@data)
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
