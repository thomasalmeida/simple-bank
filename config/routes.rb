Rails.application.routes.draw do
  post '/signup', to: 'users#create'
  post '/signin', to: 'auth#signin'
end
