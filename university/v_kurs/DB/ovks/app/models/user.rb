class User < ActiveRecord::Base
  validates :login, presence: true
  validates :fio, presence: true
  has_secure_password

  def first_name
    fio.split(' ')[0]
  end
end
