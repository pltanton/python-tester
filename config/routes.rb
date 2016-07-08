Rails.application.routes.draw do
  root to: 'submissions#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'

  resources :tests
  resources :submissions, only: %i(index create show)
  resources :tasks
  resources :users
end
