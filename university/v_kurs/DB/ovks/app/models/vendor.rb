class Vendor < ActiveRecord::Base
  validates_presence_of :title

  has_many :bills

  default_scope { order(:title) }

end