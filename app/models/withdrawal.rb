class Withdrawal < ApplicationRecord
  belongs_to :source, :class_name => 'Account'

  validates :amount, numericality: true
  validates :source, :amount, presence: true
end
