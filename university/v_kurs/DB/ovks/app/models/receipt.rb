class Receipt < ActiveRecord::Base
  include Search
  
  before_save :save_file
  
  has_many :bill_positions
  belongs_to :employee
  belongs_to :user

  validates_presence_of :ovks_num

  def rowspan
    count = bill_positions.count
    count+1
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
