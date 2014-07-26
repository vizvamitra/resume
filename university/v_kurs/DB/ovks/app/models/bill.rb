class Bill < ActiveRecord::Base
  include Search

  before_save :save_scan
  before_save :save_closing_scan

  validates_presence_of :ovks_num, :bill_num, :bill_date, :vendor_id, :total_sum
  validates_numericality_of :total_sum
  validates_uniqueness_of :ovks_num

  belongs_to :vendor
  has_many :bill_positions, dependent: :destroy

  def rowspan
    count = bill_positions.count
    count==1 ? 1 : count+1
  end

  private

  def save_scan
    return true if skan.is_a? String
    if skan
      filename = filename = save_file(skan)
      self.skan = "/uploads/#{filename}"
    end
  end

  def save_closing_scan
    return true if closing_skan.is_a? String
    if closing_skan
      filename = save_file(closing_skan)
      self.closing_skan = "/uploads/#{filename}"
    end
  end

  def save_file file
    filename = "#{Time.now.to_i}_#{file.original_filename}"
    File.open(Rails.root.join('public', 'uploads', filename), 'wb') do |f|
      f.write(file.read)
    end
    filename
  end
end
