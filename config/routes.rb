Rails.application.routes.draw do
  devise_for :users

  resources :contacts do
    member do
      get 'versions', to: 'contacts#versions'
      post 'revert_version/:id', to: 'contacts#revert', as: 'revert_version'
    end
  end

  #devise_for :users

  root to: 'contacts#index'
end