class ApplicationController < ActionController::Base

    before_action :set_locale

    def set_locale
      puts params[:locale]
      I18n.locale = params[:locale];
    end
  
    def set_language
      puts params
      redirect_back(fallback_location: root_path)
    end
end
