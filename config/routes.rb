Rails.application.routes.draw do
  devise_for :users
  root to: "schedules#index"
  resources :teams
  resources :schedules
  resources :trading_companies

end
