class Type < ActiveRecord::Base
  validates_presence_of :name

  has_many :bill_positions
  has_many :items

  default_scope { order(:name) }
end
