class Account < ApplicationRecord
  has_many :deposits, :class_name => 'Transfer', :foreign_key => 'destination_id'
  has_many :withdrawals, :class_name => 'Transfer', :foreign_key => 'source_id'

  def balance
    sum_deposits, sum_withdrawals = 0, 0

    self.withdrawals.to_a.each { |w| sum_withdrawals += w.amount }
    self.deposits.to_a.each { |w| sum_deposits += w.amount }

    sum_deposits - sum_withdrawals
  end
end
