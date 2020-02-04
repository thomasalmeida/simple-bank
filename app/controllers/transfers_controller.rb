class TransfersController < ApplicationController
  before_action :check_balance, only: [:create]

  def create
    transfer = Transfer.create(transfer_params) 

    if transfer.valid?
      render json: { transfer: transfer }, status: :created
    else
      render json: { errors: transfer.errors.full_messages }, status: :not_acceptable
    end
  end

  private 

  def transfer_params
    params.permit(:source_id, :destination_id, :amount)
  end

  def check_balance
    account = Account.find params[:source_id]
    if account.balance < params[:amount].to_f
      render json: { failure: 'not balance' }, status: :not_acceptable
    end
  end
end
