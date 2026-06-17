Rails.application.routes.draw do

  resources :jugadas do
    collection do
      get 'detalle_jugadas'
      get 'tabla_portafolio'
      get 'tabla_usuario'
      get 'tabla_buscar'
    end
    resources :jugadasdocs, only: [:create, :destroy]
  end

  post 'jugadas/nueva_shoe', to: 'jugadas#nueva_shoe', as: :nueva_shoe_jugada
  post 'jugadasdetalles/undo',   to: 'jugadasdetalles#undo'
  post 'jugadasdetalles/reset',  to: 'jugadasdetalles#reset'
  post 'jugadasdetalles/finish', to: 'jugadasdetalles#finish'
  post 'jugadasdetalles/activar_zapatos', to: 'jugadasdetalles#activar_zapatos'

  resources :jugadasdetalles, only: [:index, :new, :create] do
    collection do
      post :undo
      post :reset
    end
  end


  mount ActionCable.server => '/cable'

  resources :notificacionesplataformas, only: [:index] do
    member do
      patch :marcar_como_leida
    end
    collection do
      patch :marcar_todas_como_leidas
      get :contador # ← AGREGAR ESTA LÍNEA
    end
  end

  resources :iparametros do
    resources :iparametrosformatos
    collection do
      get 'agregar_usuario'
      get 'agregar_formato'
    end
  end

  resources :iparametrosusers
  resources :ejecuciones
  resources :municipios

  get 'errors/internal_server_error'

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  scope "/admin" do
    resources :audits do
      collection do
        get 'busqueda'
      end
    end
    resources :registros
    resources :usersactivos do
      collection do
        get 'cerrarsesion'
      end
    end
  end

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users_controller', passwords: 'users/passwords' }

  devise_scope :user do
    scope :users, as: :users do
      get 'pre_otp', to: 'users/sessions#pre_otp'
    end

    post "/users/sessions/verify_otp" => "users/sessions#verify_otp"

    authenticated :user do
      root 'menus#index'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    put 'users' => 'devise/registrations#update', as: 'user_registration'
    get 'users/edit' => 'devise/registrations#edit', as: 'edit_user_registration'
    delete 'users' => 'devise/registrations#destroy', as: 'registration'
    get 'logout' => 'devise/sessions#destroy'
  end

  resources :portafolios do
    resources :portafoliospersonas
  end

  resources :parametros

  # chain_selects

  resources :modulos
  resources :objetos

  scope "/admin" do
    resources :users do
      get :autocomplete_identificacion_nombre, on: :collection
      get :autocomplete_cambio_user2, on: :collection
      get :autocomplete_user_nombre, on: :collection
      collection do
        get 'tabhome'
        get 'resetpass'
        get 'reestablecesusuario'
        get 'cambiousuario'
        get 'cargar'
        get 'cargar2'
        get 'inconsistencias'
        get 'fincargue'
        get 'actemail'
        post 'updateemailedu'
        get 'modogestion'
        get 'modograficoedu'
        get 'desbloquearusuario'
        get 'desbloquearusuariop'
        get 'desbloquearusuariof'
        get 'activaruser'
        get 'inactivaruser'
        get 'cambioportafolio'
        get 'cambiotipoconsulta'
        get 'cambiosucursal'
        get 'cambiarperfil'
        get 'masivo'
        get 'updatepass'
        post 'etapar'
        get 'etapa'
        get 'act'
        get 'edupol_desbloquearusuario'
        get 'carguemasivo'
        post 'importar'
        post 'importar2'
        get 'permisosymodulos'
        get 'searchall'
        get 'copyusers'
        get 'restableceyenvia'
        get  'pendientes_extension'
        post 'bloquear_extensiones'
        post 'aprobar_extension'
        patch 'set_access_expiration'
      end
      resources :usersvehiculos
      resources :usersmodulos
      resources :userspermisos
      resources :usersparametros
      resources :usersreportes
      resources :userssucursales
      resources :usersportafolios
      resources :usersvisitas
      resources :usersfechas
      resources :usersimagenes
      resources :usersdocs, only: [:create, :destroy]
      resources :migracionesusers

    end
  end

  # Pantalla de acceso expirado (fuera del scope /admin para que la vea el usuario PERSONA)
  resources :access_expired, only: [:index] do
    collection do
      post :solicitar_extension   # "Sí, quiero continuar"
      post :rechazar_acceso       # "No, cerrar sesión"
    end
  end

  resources :usersmodulos do
    get :menu, on: :collection
    get :datos, on: :collection
    get :aprobarterminos, on: :collection
  end

  resources :menus do
    collection do
      get 'menu'
      post :index
    end
  end
end
