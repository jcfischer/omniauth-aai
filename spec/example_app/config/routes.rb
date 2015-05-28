Rails.application.routes.draw do
  match '/auth/logout',  :to => 'session#destroy', :as => 'logout'
  match '/auth/failure', :to => 'session#failure', :as => 'auth_failure'
  match '/auth/:provider/callback', :to => 'session#create', :as => 'auth_callback'
  get "welcome/index"
  get "welcome/protected"

  root to: 'welcome#index'
end
