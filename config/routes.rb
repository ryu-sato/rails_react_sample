# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  root 'tops#index'

  resources :parents, only: %i[index]
  
  get 'search', to: 'tops#search'
  
  defaults format: :json do
    namespace :api do
      namespace :v1 do
        resources :parents, only: %i[show] do
          resources :children, only: %i[index create]
        end
        get 'search', to: 'search#full_text'
      end
    end
  end
end
