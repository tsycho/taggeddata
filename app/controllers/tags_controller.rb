class TagsController < ApplicationController
  def show
    @tags = parse_tags(params["tags"] || "")
    @function = (params["function"] || "avg").downcase

    if @tags.count == 0
      redirect_to data_path
    else
      @data = Datum.all_tags(@tags)
      @data = current_user ?
                  @data.where("user_id = #{current_user.id} OR is_public = 't'") :
                  @data.where(:is_public => true)
      @data = @data.order("date DESC")

      # Average and group by date via direct SQL
      sql = grouped_sql_query(@function, true, @tags, "date")
      results = ActiveRecord::Base.connection.execute(sql)
      @grouped_data = {}
      results.each { |row| @grouped_data[row["date"]] = row["computed_value"].to_f }
    end
  end

private
  def grouped_sql_query(group_func, include_public, tags, group_by_col)
    "SELECT date, #{group_func}(value) AS computed_value FROM data " +
    where_clause(include_public, "tags @> ARRAY[#{tags.map {|t| '\''+t+'\''}.join(',')}] ") +
    "GROUP BY #{group_by_col}"
  end

  def where_clause(include_public, and_clause)
    if current_user && include_public
      "WHERE (user_id = #{current_user.id} OR is_public = 't') AND #{and_clause}"
    elsif current_user
      "WHERE user_id = #{current_user.id} AND #{and_clause}"
    elsif include_public
      "WHERE is_public = 't' AND #{and_clause}"
    else
      "WHERE #{and_clause}"
    end
  end
end
