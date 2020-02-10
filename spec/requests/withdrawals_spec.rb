require 'rails_helper'

RSpec.describe 'Withdrawals', type: :request do
  describe 'POST /withdrawals' do
    before(:all) do
      5.times { Account.create() }

      user = User.create(email: 'user@email.com', password: 'password', password_confirmation: 'password')
      post '/signin', params: {email: user.email, password: user.password }

      @token = JSON.parse(response.body)['jwt']
    end

    context 'with user authenticate' do
      it 'not creates a withdrawal without balance' do
        source = Account.all.sample
        post '/withdrawals', {
          params: {
            source_id: source.id,
            amount: rand(1..9999)/100
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :not_acceptable
        expect(JSON.parse(response.body)['failure']).equal? 'no balance'
      end

      it 'creates a withdrawal with balance' do
        source = Account.all.sample
        amount = rand(1..9999)/100
        Deposit.create(destination_id: source.id, amount: amount)

        post '/withdrawals', {
          params: {
            source_id: source.id,
            amount: amount
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :created
      end
    end

    context 'with user NOT authenticate' do
      it 'not creates a withdrawal without balance' do
        source = Account.all.sample
        post '/withdrawals', {
          params: {
            source_id: source.id,
            amount: rand(1..9999)/100
          }
        }
        expect(response).to have_http_status :unauthorized
        expect(JSON.parse(response.body)['failure']).equal? 'no balance'
      end

      it 'not creates a withdrawal with balance' do
        source = Account.all.sample
        amount = rand(1..9999)/100
        Deposit.create(destination_id: source.id, amount: amount)

        post '/withdrawals', {
          params: {
            source_id: source.id,
            amount: amount
          }
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    after(:all) do
      User.delete_all
      Account.delete_all
      Deposit.delete_all
      Withdrawal.delete_all
    end
  end
end
