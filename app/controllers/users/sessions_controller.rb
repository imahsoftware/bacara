class Users::SessionsController < Devise::SessionsController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create
  prepend_before_action :verify_signed_out_user, only: :destroy
  prepend_before_action only: [:create, :destroy]

  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if self.resource.bloqueo == "SI"
      flash[:alert] = I18n.t(:cannot_access_until_process_finishes)
      sign_in(resource_name, resource) # lo firma igual, por si Devise necesita sesión
      redirect_to root_path and return
    end
    if self.resource.activo == "S"
      if self.resource.ingresoseguro == 'SI'
        sign_in(resource_name, resource)
        if self.resource.otp_required_for_login == nil
          redirect_to activate_two_factor_index_path
        else
         set_flash_message!(:notice, :signed_in)
          respond_with resource, location: after_sign_in_path_for(resource)
        end
      else
        set_flash_message!(:notice, :signed_in)
        respond_with resource, location: after_sign_in_path_for(resource)
      end
      self.resource.save(validate: false)
      cookies.signed[:user_id] = self.resource.id
      cookies.signed[:username] = self.resource.username
    else
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :alert, :user_status if signed_out
      yield if block_given?
      respond_to_on_destroy
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to_on_destroy
    cookies.delete :user_id
    cookies.delete :username
  end

  def pre_otp
    user = User.find_by(username: params[:username])
    @otp_ok = user && user.otp_required_for_login
    respond_to do |format|
      format.js {
        @otp = user.current_otp if @otp_ok
      }
    end
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def translation_scope
    'devise.sessions'
  end

  private
  # Check if there is no signed in user before doing the sign out.
  #
  # If there is no signed in user, it will set the flash message and redirect
  # to the after_sign_out path.
  def verify_signed_out_user
    if all_signed_out?
      set_flash_message! :notice, :already_signed_out

      respond_to_on_destroy
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }

    users.all?(&:blank?)
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to root_path(resource_name) }
    end
  end
end
