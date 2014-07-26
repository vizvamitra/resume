class Concert < ActiveRecord::Base
	belongs_to :tour

	def self.get_one(id)
		result = Concert.find_by_sql("SELECT * FROM concerts
		                           		WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_by_tour_id(id)
		Concert.find_by_sql("SELECT * FROM concerts
			 									 WHERE tour_id = #{id}")
	end

	def save
		if self.date == ''
      self.errors.add(:date, "Необходимо указать дату")
    	false
    elsif self.country == ''
    	self.errors.add(:country, "Необходимо указать страну")
    	false
    else
      query = "INSERT INTO concerts (country,
	                                   city,
	                                   date,
	                                   tour_id,
	                                   created_at, 
	                                	 updated_at)
               VALUES ('#{country}',
                       '#{city}',
                       '#{date}',
                        #{tour_id},
                       '#{Time.now.to_s(:db)}',
                       '#{Time.now.to_s(:db)}')"
			begin
      	ActiveRecord::Base.connection.insert(query)
      	true
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
    		false
    	end
    end
	end

	def update(new_data)
		if new_data['date'] == ''
      self.errors.add(:date, "Необходимо указать дату")
    	false
    elsif new_data['country'] == ''
    	self.errors.add(:country, "Необходимо указать страну")
    	false
    else
			query = "UPDATE concerts
	             SET country = '#{new_data['country']}',
	                 city = '#{new_data['city']}',
	                 date = '#{new_data['date']}',
	                 updated_at = '#{Time.now.to_s(:db)}'
	             WHERE id=#{id};"
	    begin
	    	ActiveRecord::Base.connection.execute(query)
	    	true
	    rescue => e
	    	self.errors[:base] << "Произошла ошибка"
	    	false
	    end
	  end
	end

	def delete
		query = "SELECT COUNT(*) FROM concerts WHERE tour_id=#{self.tour_id}"
		begin
			count = ActiveRecord::Base.connection.execute(query)[0][0]
			if count == 1
				self.errors[:base] << "Нельзя удалить последний концерт."
				false
			else
				query = "DELETE FROM concerts WHERE id = #{id}"
				ActiveRecord::Base.connection.execute(query)
			end
		rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end

	def self.search_for(string)
    query ="SELECT
    						id, date, city, country,
    						t_title, tid,
    						g_title, gid
    				FROM (
    					SELECT *
	    				FROM
	    					concerts c
	    				INNER JOIN
		    				( SELECT id AS tid, group_id, title AS t_title
		    					FROM tours
		    				) t ON t.tid = c.tour_id
							INNER JOIN
								( SELECT title AS g_title, id AS gid
									FROM groups
								) g ON t.group_id = g.gid
						)
            WHERE city LIKE '%#{string}%'
               OR country LIKE '%#{string}%'
               OR date LIKE '%#{string}%'"
    Concert.find_by_sql(query)
  end
end