class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_top5_groups

private

	def get_top5_groups
		sql = ActiveRecord::Base.connection()
		result = sql.execute("SELECT title, top_position FROM groups WHERE top_position IS NOT NULL ORDER BY top_position LIMIT 5")
		@top5_groups = []
		result.each() do |row|
			@top5_groups << row
		end
	end

	def transact(sql_string)
	  sql = ActiveRecord::Base.connection()
	  begin
	    sql.execute("START TRANSACTION")
	    result = sql.execute(sql_string)
	    sql.execute("COMMIT")
	    result == nil ? true : result
	  rescue 
	    sql.execute("ROLLBACK")
	    false
	  end
	end
end
