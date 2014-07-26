class SzType < ActiveRecord::Base
  has_many :szs

  validates_presence_of :name
end
