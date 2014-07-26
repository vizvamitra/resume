class Item < ActiveRecord::Base
  include Search
  
  belongs_to :sz
  belongs_to :nz
  belongs_to :type

  def owner
    sz_id ? sz : nz
  end
end
