class Nz < ActiveRecord::Base
  include Search
  
  before_save :save_file
  
  validates_presence_of :ovks_num
  validates_uniqueness_of :ovks_num

  belongs_to :manager, class_name: "Employee", foreign_key: :manager_id
  belongs_to :given_to, class_name: "Employee", foreign_key: :given_to_id

  has_many :items, dependent: :destroy

  scope :not_done, -> { where(given_to_id: nil) }

  def grouped_items
    Item.where(nz_id: id).select("'items'.*, COUNT(name) AS count").group(:name).load
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
