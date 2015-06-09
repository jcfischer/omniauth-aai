Rails.application.routes.draw do

  get '/auth/logout',  to: 'session#destroy', as: 'logout'
  get '/auth/failure', to: 'session#failure', as: 'auth_failure'
  post '/auth/:provider/callback', to: 'session#create', as: 'auth_callback'
  get "welcome/index"
  get "welcome/protected"

  root to: 'welcome#index'
end
