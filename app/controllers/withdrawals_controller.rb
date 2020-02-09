class WithdrawalsController < ApplicationController
before_action :check_balance, only: [:create]

def create
    withdrawal = Withdrawal.create(withdrawal_params) 

    if withdrawal.valid?
      render json: { withdrawal: withdrawal }, status: :created
    else
      render json: { errors: withdrawal.errors.full_messages }, status: :not_acceptable
    end
  end

  private 

  def withdrawal_params
    params.permit(:source_id, :amount)
  end

  def check_balance
    account = Account.find params[:source_id]
    if account.balance < params[:amount].to_f
      render json: { failure: 'no balance' }, status: :not_acceptable
    end
  end
end
