Rails.application.routes.draw do

  get '/auth/login', to: 'sessions#new', as: 'login'
  get '/auth/logout',  to: 'sessions#destroy', as: 'logout'
  get '/auth/failure', to: 'sessions#failure', as: 'auth_failure'
  post '/auth/:provider/callback', to: 'sessions#create', as: 'auth_callback'
  get "welcome/index"
  get "welcome/protected"

  root to: 'welcome#index'
end
