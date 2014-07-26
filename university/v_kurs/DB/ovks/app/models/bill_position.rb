class BillPosition < ActiveRecord::Base
  include Search
  
  validates_presence_of :type_id, :model, :bill_id

  belongs_to :bill
  belongs_to :type
  belongs_to :sz
  belongs_to :nz
  belongs_to :receipt

  def has_reason?
    sz_id || nz_id
  end

  def reason
    (sz_id ? sz : nz) if has_reason?
  end

  def self.filter(filter)
    if (filter.is_a?(Hash) && filter.key?(:field) && filter.key?(:value))
      field = filter[:field].to_sym
      value = filter[:value].to_sym
      self.where(field => value)
    else
      self.unscoped
    end
  end

end
