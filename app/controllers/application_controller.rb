class ApplicationController < ActionController::Base
  before_action :permit_extra_devise_registration_parameters, if: :devise_controller?

  protected

  def permit_extra_devise_registration_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role_id, :name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
