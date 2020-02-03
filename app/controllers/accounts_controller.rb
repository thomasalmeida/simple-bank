class AccountsController < ApplicationController
  def create
    account = Account.create() 

    render json: { account: account }
  end

  def get_balance
    begin
      account = Account.find(params[:account_id])

      render json: { balance: account.balance }
    rescue => exception
      render json: { errors: exception.message }, status: :not_found
    end
  end

  # def get_balance(account)
  #   sum_deposits, sum_withdrawals = 0, 0
    
  #   account.withdrawals.to_a.each { |w| sum_withdrawals += w.amount }
  #   account.deposits.to_a.each { |w| sum_deposits += w.amount }

  #   sum_deposits - sum_withdrawals
  # end
end
