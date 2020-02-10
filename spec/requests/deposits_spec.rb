require 'rails_helper'

RSpec.describe 'Deposits', type: :request do
  describe 'POST /deposits' do
    before(:all) do
      5.times { Account.create() }

      user = User.create(email: 'user@email.com', password: 'password', password_confirmation: 'password')
      post '/signin', params: {email: user.email, password: user.password }

      @token = JSON.parse(response.body)['jwt']
    end

    context 'with user authenticate' do
      it 'creates a deposit' do
        destination = Account.all.sample
        amount = rand(1..9999)/100

        post '/deposits', {
          params: {
            destination_id: destination.id,
            amount: amount
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :created
        expect(destination.balance).to equal amount.to_f
      end

      it 'not creates a deposit in an account unexisted' do
        post '/deposits', {
          params: {
            destination_id: Account.last.id + 1,
            amount: rand(1..9999)/100
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :not_acceptable
      end
    end

    context 'with user NOT authenticate' do
      it 'not creates a deposit' do
        destination = Account.all.sample
        amount = rand(1..9999)/100

        post '/deposits', {
          params: {
            destination_id: destination.id,
            amount: amount
         }
        }
        expect(response).to have_http_status :unauthorized
      end

      it 'not creates a deposit in an account unexisted' do
        post '/deposits', {
          params: {
            destination_id: Account.last.id + 1,
            amount: rand(1..9999)/100
         }
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    after(:all) do
      User.delete_all
      Account.delete_all
      Deposit.delete_all
    end
  end
end
