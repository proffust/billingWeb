Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    member do
      post 'activate'
      post 'deactivate'
    end
  end
  resources :nats
end
