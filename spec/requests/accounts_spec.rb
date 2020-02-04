require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  describe 'GET /accounts' do
    context 'with user authenticate' do
      before(:all) do
        2.times { Account.create }
        2.times { Transfer.create(source_id: Account.first.id, destination_id: Account.last.id, amount: 1.11) }

        user = User.create(email: 'user@email.com', password: 'password', password_confirmation: 'password')
        post '/signin', params: {email: user.email, password: user.password }

        @token = JSON.parse(response.body)['jwt']
      end

      it 'creates an account' do
        get '/accounts', { params: {}, headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" } }
        expect(response).to have_http_status :created
      end

      it 'check balance' do
        get "/accounts/balance/#{Account.last.id}", { params: {}, headers: { 'HTTP_AUTHORIZATION': "Bearer #{@token}" } }
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['balance']).to equal 2.22
      end

      after(:all) do
        User.delete_all
        Account.delete_all
        Transfer.delete_all
      end
    end

    context 'with user NOT authenticate' do
      it 'dont creates an account' do
        get '/accounts'
        expect(response).to have_http_status :unauthorized
      end

      it 'dont check balance' do
        get '/accounts/balance/1'
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
