Rails.application.routes.draw do
  devise_for :users
  root to: "teams#new"
  resources :teams

end
