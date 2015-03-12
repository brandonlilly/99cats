Rails.application.routes.draw do
  root to: "cats#index"
  resources :cats
  resources :cat_rental_requests do
    member do
      post '/approve' => 'cat_rental_requests#approve'
      post '/deny' => 'cat_rental_requests#deny'
    end
  end
  resource :user, only: [:create, :new, :show]
  resources :sessions, only: [:new, :create, :destroy, :index]
end
