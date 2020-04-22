Rails.application.routes.draw do
  resources :users, only: %i[create]
  resources :movies, except: %i[new edit]
  resources :seasons, except: %i[new edit] do
    resources :episodes, except: %i[new edit]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
