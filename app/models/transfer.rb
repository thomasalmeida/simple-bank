class Transfer < ApplicationRecord
  belongs_to :destination, :class_name => 'Account'
  belongs_to :source, :class_name => 'Account'

  validates :amount, numericality: true
  validates :source, :destination, :amount, presence: true
  validates_each :destination do |record, attr, _value|
    if record.destination_id == record.source_id
      record.errors.add(attr, 'must be different from Source')
    end
  end
end
