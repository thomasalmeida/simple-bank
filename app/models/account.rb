class Account < ApplicationRecord
  has_many :transfer_deposits, :class_name => 'Transfer', :foreign_key => 'destination_id'
  has_many :transfer_withdrawals, :class_name => 'Transfer', :foreign_key => 'source_id'

  has_many :deposits, :class_name => 'Deposit', :foreign_key => 'destination_id'
  def balance
    sum_deposits, sum_withdrawals = 0, 0

    self.withdrawals.to_a.each { |w| sum_withdrawals += w.amount }
    self.deposits.to_a.each { |w| sum_deposits += w.amount }

    sum_deposits - sum_withdrawals
  end
end
