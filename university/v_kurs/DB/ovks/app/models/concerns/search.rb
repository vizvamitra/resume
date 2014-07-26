module Search
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query, *fields) {
      query_string = ""
      fields.each do |field|
        query_string += "UPPER(#{field.to_s}) LIKE UPPER('%#{query}%') "
        query_string += 'OR ' unless field == fields.last
      end
      where(query_string)
    }
  end

  def field_with query
    attributes.select{|k,v| k !~ /id|count/}.values.each { |value| return value if value.to_s.match(query) }
    nil
  end

end