class ApplicationController < ActionController::Base
  before_filter :set_current_site

  before_action :make_action_mailer_use_request_host_and_protocol
  before_action :set_raven_context

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionHelper
  
  helper_method :site_logo_url

  def site_logo_url
    @site_logo_url ||= @current_site.setting("logo_url")
  end

  private
    def set_current_site
      @current_site = Site.find_by_subdomain!(request.subdomains.first)
    end

    def set_program
      @program = @current_site.programs.find(params[:program_id])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:warning] = "Please sign in."
        redirect_to login_url
      end
    end

    def ensure_admin
      render inline: '<h1>Access Denied</h1>' unless current_user && current_user.admin?
    end

    def ensure_program_access(program)
      render 'programs/no_access' unless current_user && 
                                         current_user.has_access?(program)
    end

    def make_action_mailer_use_request_host_and_protocol
      ActionMailer::Base.default_url_options[:protocol] = request.protocol
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
      ActionMailer::Base.asset_host = "#{request.protocol}#{request.host_with_port}"
    end

    def set_raven_context
      if defined?(Raven)
        Raven.user_context(user_id: current_user.email) if current_user
        Raven.extra_context(params: params.to_hash, url: request.url)
      end
    end
end
