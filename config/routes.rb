Rails.application.routes.draw do
  resources :contests
  #mount ActionCable.server => '/cable' 

  root to: 'contests#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  resources :submissions, only: %i(index create show)
  resources :tasks
  resources :users
end
