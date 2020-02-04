require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'POST /signin' do
    context 'with valid parameters' do
      before(:all) do
        User.create(email: 'user@email.com', password: 'password', password_confirmation: 'password')
      end

      let(:valid_params) do
        {
          email: 'user@email.com',
          password: 'password'
        }
      end

      it 'login as an user' do
        post '/signin', params: valid_params
        expect(response).to have_http_status :ok
      end
    end

    after(:all) do
      User.delete_all
    end
  end
end
