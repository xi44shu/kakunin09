Rails.application.routes.draw do
  devise_for :users
  root to: "schedules#index"
  resources :teams
  resources :schedules do
    member do
      get 'copy'
    end
  end
  resources :trading_companies

end
