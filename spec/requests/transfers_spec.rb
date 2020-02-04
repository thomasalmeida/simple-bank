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
        post '/transfers', {
          params: {
            source_id: Account.all.sample.id,
            destination_id: Account.all.sample.id,
            amount: rand(9)
          },
          headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" }
        }
        expect(response).to have_http_status :not_acceptable
        expect(JSON.parse(response.body)['failure']).equal? 'not balance'
      end

      it 'not creates a transfer identical source and destination' do
        post '/transfers', {
          params: {
            source_id: Account.first.id,
            destination_id: Account.first.id,
            amount: rand(9)
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
            amount: rand(9)
          }
        }
        expect(response).to have_http_status :unauthorized
      end

      it 'not creates a transfer identical source and destination' do
        post '/transfers', {
          params: {
            source_id: Account.first.id,
            destination_id: Account.first.id,
            amount: rand(9)
          }
        }
        expect(response).to have_http_status :unauthorized
      end
    end

    after(:all) do
      User.delete_all
      Account.delete_all
    end
  end
end
