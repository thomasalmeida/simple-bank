class Account < ApplicationRecord
  has_many :transfer_deposits, :class_name => 'Transfer', :foreign_key => 'destination_id'
  has_many :transfer_withdrawals, :class_name => 'Transfer', :foreign_key => 'source_id'

  has_many :deposits, :class_name => 'Deposit', :foreign_key => 'destination_id'
  has_many :withdrawals, :class_name => 'Withdrawal', :foreign_key => 'source_id'

  def balance
    deposits_sum(self) - withdrawals_sum(self)
  end

  private

  def deposits_sum(account)
    sum = 0
    account.deposits.each { |d| sum += d.amount }
    account.transfer_deposits.to_a.each { |d| sum += d.amount }

    sum
  end

  def withdrawals_sum(account)
    sum = 0
    account.withdrawals.each { |w| sum += w.amount }
    account.transfer_withdrawals.to_a.each { |w| sum += w.amount }

    sum
  end
end
