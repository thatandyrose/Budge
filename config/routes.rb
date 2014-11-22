Rails.application.routes.draw do
  
  resources :transactions do
    get :import, on: :collection
  end

  root to: 'visitors#index'
  devise_for :users
end
