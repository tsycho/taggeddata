class TagsController < ApplicationController
  # TODO: Remove this and add support for unauthenticated search over public data.
  before_action :require_login

  def show
    @tags = (params["tags"] || "")
              .split(/[\s,]+/)
              .map { |t| t[0]=='#' ? t[1..-1] : t }
              .map { |t| t.downcase }
              .select { |t| t.length > 0 }

    @function = (params["function"] || "avg").downcase

    if @tags.count == 0
      redirect_to data_path
    else
      # TODO: Combine SQL queries below.
      @data = Datum.all_tags(@tags).where(:user => current_user).order("date DESC")

      # Average and group by date via direct SQL
      results = ActiveRecord::Base.connection.execute("SELECT date, #{@function}(value) AS computed_value from data WHERE user_id = #{current_user.id} AND tags @> ARRAY[#{@tags.map {|t| '\''+t+'\''}.join(',')}] GROUP BY date")
      @grouped_data = {}
      results.each { |row| @grouped_data[row["date"]] = row["computed_value"].to_f }
    end
  end
end
