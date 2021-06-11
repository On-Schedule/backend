Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "users/login", to: "users#login"
      resources :users, only: [:show, :create]
    end
  end
end
