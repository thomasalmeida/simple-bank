Rails.application.routes.draw do
  post '/signup', to: 'users#create'
  post '/signin', to: 'auth#signin'

  get '/accounts', to: 'accounts#create'
  get '/accounts/balance/:account_id', to: 'accounts#get_balance'

  post '/transfers', to: 'transfers#create'

  post '/deposits', to: 'deposits#create'
  post '/withdrawals', to: 'withdrawals#create'
end
