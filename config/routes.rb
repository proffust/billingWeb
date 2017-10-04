Rails.application.routes.draw do
  devise_for :auth_users
  get 'persons/profile'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    member do
      get 'activate'
      get 'deactivate'
      get 'extend'
    end
  end
  resources :nats do
    member do
      get 'activate'
      get 'deactivate'
    end
  end
  root 'users#index'
end
