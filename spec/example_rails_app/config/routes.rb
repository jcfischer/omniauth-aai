TestApp1::Application.routes.draw do
  get "welcome/index"

  get "welcome/protected"

  root :to => 'welcome#index'
end
