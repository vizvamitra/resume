class Department < ActiveRecord::Base
  validates_presence_of :title

  has_many :employees
  has_one :employee

  default_scope { order(:title).includes(:employees) }
end
