Rails.application.routes.draw do
  devise_for :auth_users
    get 'persons/profile'

  get 'users/info'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    member do
      patch 'activate'
      patch 'deactivate'
      patch 'extend'
    end
  end
  resources :nats do
    member do
      patch 'activate'
      patch 'deactivate'
    end
  end
  root 'persons#profile'
end
