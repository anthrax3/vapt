require 'sidekiq/web'

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  resources :screenshots, only: [:new, :create, :edit, :update, :destroy]
  resources :reports
  resources :exploits do
    get :autocomplete_exploit_platform_title, on: :collection
    get :autocomplete_exploit_type_title, on: :collection
  end

  resources :customers, only: [:index, :show] do
    get :autocomplete_customer_name, :on => :collection
  end

  resources :cves, only: [:show, :index]
  resources :exploit_types, only: [:show]
  resources :exploit_platforms, only: [:show]
  resources :exploit_authors, only: [:show]
  resources :exploit_search, only: [:index]
  resources :custom_exploits, only: [:index]
  resources :nmap
  resources :engagements do
    collection do
      get 'download'
    end
    member do
      put :complete
      get :vuln_details
      get :iava
    end
    resources :ocbs, only: [:create]
    resources :nmap, only: [:new, :create, :show] do
      resources :nmap_reports, only: [:index]
    end
    resources :engagement_creds, only: [:create, :destroy, :index]
    resources :engagement_mains, only: [:create, :destroy, :update, :index] do
      resources :host_vulns, only: [:create, :update, :destroy]
      resources :engagement_main_users, only: [:index, :create]
      resources :host_creds, only: [:create, :update, :destroy]
      resources :custom_findings, only: [:create, :update, :destroy]
    end
    resources :nessus, only: [:new, :create, :show] do
      resources :nessus_reports, only: [:index]
      resources :vulns_reports, only: [:index]
    end
    resources :host_scan_details, only: [:show]
    resources :hosts, only: [:show] do
      resources :host_services, only: [:create, :update, :destroy]
    end
    resources :metasploit, only: [:new, :create, :show] do
      resources :metasploit_reports, only: [:index]
    end
    resources :metasploit_host_views, only: [:show]
  end

  resources :engagement_statuses do
    member do
      post :accept
    end
  end
  resources :notes, only: [:create, :destroy]
  resources :on_hold_engagements, only: [:show]
  resources :activate_engagements, only: [:show]
  resources :end_engagements, only: [:update]
  resources :cwes, only: [:show, :index]
  resources :cwe_categories, only: [:show]
  resources :cwe_compound_elements, only: [:show]

  get 'download_exploit/download/:id' => 'download_exploit#download', as: :download_exploit
  get '/reports/:id/penetrations/new' => 'reports#new_penetration', as: :add_new_penetration
  delete '/reports/:id/penetrations/:penetration_id' => 'reports#remove_penetration', as: :remove_penetration
  get 'reports/:id/pdf' => 'reports#get_pdf', as: :get_pdf
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 									 'static_pages#home'
  get 'signup'				=> 'users#new'
  get	'admin'					=> 'settings#edit'
  get 'login'		  		=> 'sessions#new'

  get 'users/get_stats'			 => 'users#get_stats'
  get 'user/:id/reset_password' => 'users#reset_password', as: :reset_user_password

  post 'login' 		 			=> 'sessions#create'
  post 'join'           => 'teams#join'
  post 'remove_member'  => 'teams#remove_member'

  delete 'logout'					=> 'sessions#destroy'

  patch 'settings' => 'settings#update'
  resources :teams do
    get 'add_members'
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :users do
    collection do
      get 'find_users'
    end
  end
  resources :users
  resources :teams
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  post '/engagements/:engagement_id/hosts/:host_id/evidences/list' => 'evidences#list'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/upload' => 'evidences#upload'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/rename' => 'evidences#rename'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/copy' => 'evidences#copy'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/move' => 'evidences#move'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/remove' => 'evidences#remove'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/edit' => 'evidences#edit'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/get_content' => 'evidences#get_content'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/create_folder' => 'evidences#create_folder'
  get '/engagements/:engagement_id/hosts/:host_id/evidences/download' => 'evidences#download'
  get '/engagements/:engagement_id/hosts/:host_id/evidences/download_multiple' => 'evidences#download_multiple'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/compress' => 'evidences#compress'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/extract' => 'evidences#extract'
  post '/engagements/:engagement_id/hosts/:host_id/evidences/permissions' => 'evidences#permissions'

  mount Sidekiq::Web, at: '/sidekiq'

end
