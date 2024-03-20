class ApplicationController < ActionController::Base

    before_action :set_locale
    # before_action :configure_sign_up_params, if: :devise_controller?


    def set_locale
      puts params[:locale]
      I18n.locale = params[:locale];
    end
  
    def set_language
      puts params
      redirect_back(fallback_location: root_path)
    end

    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden }
        format.html { redirect_to root_path, alert: exception.message }
      end
    end
  


end
