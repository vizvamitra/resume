class Sz < ActiveRecord::Base
  include Search
  
  before_save :save_file

  belongs_to :user
  belongs_to :sz_type
  belongs_to :employee
  has_many :items, dependent: :destroy
  
  validates_presence_of :ovks_num
  validates_uniqueness_of :ovks_num

  default_scope { order(:ovks_num) }
  scope :not_done, -> { where(done: false) }

  def grouped_items
    Item.where(sz_id: id).select("'items'.*, COUNT(name) AS count, COUNT(done) AS done_count").group(:name).load
  end

  private

  def save_file
    return true if scan.is_a? String
    if scan
      filename = "#{Time.now.to_i}_#{scan.original_filename}"
      File.open(Rails.root.join('public', 'uploads', filename), 'wb') do |f|
        f.write(scan.read)
      end
      self.scan = "/uploads/#{filename}"
    end
  end

end
