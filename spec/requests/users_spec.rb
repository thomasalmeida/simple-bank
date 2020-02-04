require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /signup' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          email: 'user@email.com',
          password: 'password',
          password_confirmation: 'password'
        }
      end

      it 'creates a new user' do
        post '/signup', params: valid_params
        expect(response).to have_http_status :created
        expect(User.last.email).equal? valid_params[:email]
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          email: 'user@email.com',
          password: 'password',
          password_confirmation: 'pass'
        }
      end

      it 'not acceptable creates a new user' do
        post '/signup', params: invalid_params
        expect(response).to have_http_status :not_acceptable
      end
    end
  end
end
