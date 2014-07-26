class Employee < ActiveRecord::Base
  include Search
  
  validates_presence_of :fio

  has_many :szs
  belongs_to :department

  default_scope { order(:fio) }

  def first_name
    fio.split(' ')[0]
  end
end
