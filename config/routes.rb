Books::Application.routes.draw do
  match "auth/:provider/callback" => "sessions#create"
  get "auth/sign_out" => "sessions#sign_out", :as => :sign_out

  resources :sessions, :only => :new do
    get :failure, :collection => true
  end

  resources :copy, :controller => "copies" do
    collection do
      post :lookup
    end

    member do
      post :borrow
      post :return
      post :nudge
    end
  end

  get '/books/isbn/:isbn' => "books#lookup_isbn", :as => :book_isbn_lookup
  get '/books/list' => "books#index", :as => :book_list, :display => 'list'

  resources :devices, :books do
    member do
      get :history
      post :restore
    end

    collection do
      get :list, :action => "index", :display => 'list'
    end

    resources :copies, :only => [:new, :create]
  end

  resources :user, :only => :show

  root :to => "root#start"
end
