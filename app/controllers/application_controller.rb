class ApplicationController < ActionController::Base

    before_action :set_locale
    # before_filter :set_locale

    def set_locale
      puts params[:locale]
      I18n.locale = session[:locale]  || I18n.default_locale
    end


    def switch_locale
      locale = params[:locale].to_sym
      locale = I18n.default_locale unless I18n.available_locales.include?(locale)
      session[:locale] = locale
      # I18n.locale = session[:locale]
      redirect_to params[:redirect_to] || root_path
    end
  

    rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden }
        format.html { redirect_to root_path, alert: exception.message }
      end
    end
end
