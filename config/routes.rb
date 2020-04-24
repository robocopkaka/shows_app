Rails.application.routes.draw do
  resources :users, only: %i[create] do
    resources :libraries, only: %i[create index]
  end
  resources :movies, except: %i[new edit]
  resources :seasons, except: %i[new edit] do
    resources :episodes, except: %i[new edit index]
  end
  resources :all_shows, only: %i[index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
