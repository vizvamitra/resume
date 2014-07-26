class Member < ActiveRecord::Base
	belongs_to :group

	validates :name, presence: true

	def self.get_one(id)
		result = Member.find_by_sql("SELECT * FROM members
		                            WHERE id=#{id} LIMIT 1")
		result[0]
	end

	def self.get_by_group_id(id, order_by, order)
		Member.find_by_sql("SELECT * FROM members
			 								 WHERE group_id = #{id}
                       ORDER BY #{order_by} #{order}")
	end

	def save
		if self.name == ''
      self.errors.add(:name, "Необходимо указать имя")
    	false
    else
      query = "INSERT INTO members (name,
                                    role,
                                    birth_date,
                                    group_id,
                                    created_at, 
                                  	updated_at)
               VALUES ('#{name}',
                       '#{role}',
                       '#{birth_date}',
                        #{group_id},
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
		if new_data['name'] == ''
			self.errors.add(:name, "Необходимо указать имя")
    	false
		else
  		query = "UPDATE members
               SET name = '#{new_data['name']}',
                   role = '#{new_data['role']}',
                   birth_date = '#{new_data['birth_date']}',
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
		query = "DELETE FROM members WHERE id = #{id}"
		begin
    	ActiveRecord::Base.connection.execute(query)
    rescue => e
    	self.errors[:base] << "Произошла ошибка"
    	false
    end
	end

  def self.search_for(string)
    query ="SELECT * FROM members m
            INNER JOIN
              ( SELECT id AS gid, title AS g_title
                FROM groups
              ) g ON g.gid = m.group_id
            WHERE name LIKE '%#{string}%'
               OR role LIKE '%#{string}%'"
    Member.find_by_sql(query)
  end
end
