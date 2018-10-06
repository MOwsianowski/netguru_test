Rails.application.routes.draw do
  devise_for :users

  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :comments, only: [:create]

  resources :movies, only: [:index, :show] do
  get 'movies/:id', to: 'movies#show', as: 'movie_show'
  get 'movies', to: 'movies#index'
    member do
      get :send_info
    end
    collection do
      get :export
    end
  end
end
