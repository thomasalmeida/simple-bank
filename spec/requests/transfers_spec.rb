require 'rails_helper'

RSpec.describe 'Transfers', type: :request do
  describe 'POST /transfers' do
    before(:all) do
      5.times { Account.create() }

      user = User.create(email: 'user@email.com', password: 'password', password_confirmation: 'password')
      post '/signin', params: {email: user.email, password: user.password }

      @token = JSON.parse(response.body)['jwt']
    end

    context 'with user authenticate' do
      it 'not creates a transfer without balance' do
        source = Account.all.sample
        destination = (Account.all - [source]).sample
        post '/transfers', {
          params: {
            source_id: source.id,
            destination_id: destination.id,
            amount: rand(1..9999)/100
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :not_acceptable
        expect(JSON.parse(response.body)['failure']).equal? 'no balance'
      end

      it 'creates a transfer with balance' do
        source = Account.all.sample
        destination = (Account.all - [source]).sample
        amount = rand(1..9999)/100
        Deposit.create(destination_id: source.id, amount: amount)

        post '/transfers', {
          params: {
            source_id: source.id,
            destination_id: destination.id,
            amount: amount
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :created
        expect(destination.balance).to equal amount.to_f
      end

      it 'not creates a transfer identical source and destination' do
        post '/transfers', {
          params: {
            source_id: Account.first.id,
            destination_id: Account.first.id,
            amount: rand(1..9999)/100
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :not_acceptable
      end
    end

    context 'with user NOT authenticate' do
      it 'not creates a transfer without balance' do
        post '/transfers', {
          params: {
            source_id: Account.all.sample.id,
            destination_id: Account.all.sample.id,
            amount: rand(1..9999)/100
          }
        }
        expect(response).to have_http_status :unauthorized
      end

      it 'not creates a transfer with balance' do
        source = Account.all.sample
        destination = (Account.all - [source]).sample
        amount = rand(1..9999)/100
        Deposit.create(destination_id: source.id, amount: amount)

        post '/transfers', {
          params: {
            source_id: source.id,
            destination_id: destination.id,
            amount: amount
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :created
        expect(destination.balance).to equal amount.to_f
      end

      it 'not creates a transfer identical source and destination' do
        post '/transfers', {
          params: {
            source_id: Account.first.id,
            destination_id: Account.first.id,
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
