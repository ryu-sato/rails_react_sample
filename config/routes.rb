# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'tops#index'

  resources :parents, only: %i[index]
  resources :tops
  
  get 'search', to: 'tops#search'
  
  namespace :api do
    namespace :v1 do
      resources :parents, only: %i[show] do
        resources :children, only: %i[index]
      end
    end
  end
end
