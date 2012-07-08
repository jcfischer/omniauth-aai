TestApp::Application.routes.draw do
  get "welcome/index"

  get "welcome/other_protected"

  match '/auth/:provider/callback', to: 'session#create', as: "auth_callback"
  match '/auth/failure', to: 'session#failure', as: "auth_failure"
  match '/auth/logout',  to: 'session#destroy', as: "logout"

  root :to => 'welcome#index'
end
