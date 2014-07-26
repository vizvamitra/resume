class Group < ActiveRecord::Base
	has_many :songs, dependent: :destroy
	has_many :members, dependent: :destroy
	has_many :tours, dependent: :destroy

	validate :top_position, greater_then: 0

	def self.get_one(id)
		result = Group.find_by_sql("SELECT * FROM groups
		                            WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_all(order_by='title', order='asc')
		Group.find_by_sql("SELECT * FROM groups ORDER BY #{order_by} #{order}")
	end

	def save
		if self.title == ''
      self.errors.add(:title, "Необходимо указать название")
    	false
    else
      query = "INSERT INTO groups (title,
                                  formation_year,
                                  country, 
                                  top_position, 
                                  created_at, 
                                  updated_at)
               VALUES ('#{title}',
                        #{formation_year || 'NULL'},
                       '#{country}',
                        #{top_position || 'NULL'},
                       '#{Time.now.to_s(:db)}',
                       '#{Time.now.to_s(:db)}')"
			begin
      	ActiveRecord::Base.connection.execute(query)
        true
      rescue => e
      	self.errors[:base] << "Произошла ошибка"
    		false
    	end
    end
	end

	def update(new_data)
    self.title = new_data['title']
    self.country = new_data['country']
    self.formation_year = new_data['formation_year']
    self.top_position = new_data['top_position']

		if new_data['title'] == ''
			self.errors.add(:title, "Необходимо указать название")
    	false
		else
  		query = "UPDATE groups
               SET title = '#{self.title}',
                   country = '#{self.country}',
                   formation_year = #{self.formation_year || 'NULL'},
                   top_position = #{self.top_position || 'NULL'},
                   updated_at = '#{Time.now.to_s(:db)}'
               WHERE id=#{id};"
      begin
      	ActiveRecord::Base.connection.execute(query)
        true
      rescue ActiveRecord::RecordNotUnique => e
      	self.errors[:top_position] << "Занято другой группой"
      	false
      rescue => e
        self.errors[:base] << "Произошла ошибка"
        false
      end      
    end
	end

	def delete
    begin
      query = "SELECT id FROM tours WHERE group_id=#{id}"
      tours = ActiveRecord::Base.connection.execute(query)
      tours.each do |tour|
        queries << "DELETE from concerts WHERE tour_id=#{tour['id']};"
      end

      queries = [
        "DELETE FROM tours WHERE group_id=#{id};",
        "DELETE FROM songs WHERE group_id=#{id};",
        "DELETE FROM members WHERE group_id=#{id};",
        "DELETE FROM groups WHERE id=#{id};"]

      queries.each do |query|
        ActiveRecord::Base.connection.execute(query)
      end
      true
    rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end

  def self.search_for(string)
    query = "SELECT * FROM groups
             WHERE title LIKE '%#{string}%'
                OR country LIKE '%#{string}%'
                OR formation_year LIKE #{string.to_i}"
    Group.find_by_sql(query)
  end
end