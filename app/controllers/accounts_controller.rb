class AccountsController < ApplicationController
  def create
    account = Account.create() 

    render json: { account: account }, status: :created
  end

  def get_balance
    begin
      account = Account.find(params[:account_id])

      render json: { balance: account.balance }, status: :ok
    rescue => exception
      render json: { errors: exception.message }, status: :not_found
    end
  end
end
