Rails.application.routes.draw do
  
  resources :transactions do
    get :apply_category_to_similar, on: :member
    get :run_rules, on: :collection
    get :import, on: :collection
  end

  root to: 'visitors#index'
  devise_for :users
end
