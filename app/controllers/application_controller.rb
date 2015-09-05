class ApplicationController < ActionController::Base
  before_filter :set_current_site
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionHelper

  private
    def set_current_site
      @current_site = Site.find_by_subdomain!(request.subdomains.first)
    end
end
