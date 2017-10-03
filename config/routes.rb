Rails.application.routes.draw do
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
end
