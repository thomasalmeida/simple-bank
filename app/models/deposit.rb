class Deposit < ApplicationRecord
  belongs_to :destination, :class_name => 'Account'

  validates :amount, numericality: true
  validates :destination, :amount, presence: true
end
