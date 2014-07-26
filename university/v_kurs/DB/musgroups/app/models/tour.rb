class Tour < ActiveRecord::Base
	belongs_to :group
	has_many :concerts, dependent: :destroy

	def self.get_one(id)
		result = Tour.find_by_sql("SELECT * FROM tours
		                            WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_by_group_id(id, order_by, order)
    Tour.find_by_sql("SELECT
                        t.id, t.title, t.group_id, d.begin_date, d.end_date
                      FROM
                        tours t
                      INNER JOIN
                        ( SELECT MIN(date) AS begin_date,
                                 MAX(date) AS end_date,
                                 tour_id
                         FROM concerts
                         GROUP BY tour_id
                        ) d ON t.id = d.tour_id
                      WHERE t.group_id=#{id}
                      ORDER BY #{order_by} #{order}")
  end

  def get_concerts(order_by, order)
    query = "SELECT * FROM concerts
             WHERE tour_id = #{id}
             ORDER BY #{order_by} #{order}"
    begin
      ActiveRecord::Base.connection.execute(query)
    rescue => e
      self.errors[:base] << "Произошла ошибка"
      nil
    end
  end

	def save
		if self.title == ''
      self.errors.add(:title, "Необходимо указать название")
    	false
    else
      query = "INSERT INTO tours (title,
                                  group_id,
                                  created_at, 
                                  updated_at)
               VALUES ('#{title}',
                        #{group_id},
                       '#{Time.now.to_s(:db)}',
                       '#{Time.now.to_s(:db)}');"
			begin
      	self.id = ActiveRecord::Base.connection.insert(query)
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
    		false
    	end
    end
	end

	def update(new_data)
		if new_data['title'] == ''
			self.errors.add(:title, "Необходимо указать название")
    	false
		else
  		query = "UPDATE tours
               SET title = '#{new_data['title']}',
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
    begin
      query = "DELETE FROM concerts WHERE tour_id=#{self.id};"
      ActiveRecord::Base.connection.execute(query)

      query = "DELETE FROM tours WHERE id=#{self.id};"
      ActiveRecord::Base.connection.execute(query)
      
      true
    rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end

  def self.search_for(string)
    query ="SELECT
              title, begin_date, end_date, id, gid, g_title
            FROM (
              SELECT
                t.id, t.title, t.group_id,
                d.begin_date, d.end_date,
                g.gid, g.g_title
              FROM
                tours t
              INNER JOIN
                ( SELECT MIN(date) AS begin_date,
                         MAX(date) AS end_date,
                         tour_id
                  FROM concerts
                  GROUP BY tour_id
                ) d ON t.id = d.tour_id
              INNER JOIN
                ( SELECT title AS g_title,
                         id AS gid
                  FROM groups
                ) g ON g.gid = t.group_id
            )
            WHERE title LIKE '%#{string}%'  "
    Tour.find_by_sql(query)
  end
end
