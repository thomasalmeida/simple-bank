class DepositsController < ApplicationController
  def create
    deposit = Deposit.create(deposit_params) 

    if deposit.valid?
      render json: { deposit: deposit }, status: :created
    else
      render json: { errors: deposit.errors.full_messages }, status: :not_acceptable
    end
  end

  private 

  def deposit_params
    params.permit(:destination_id, :amount)
  end
end
