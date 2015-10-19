class PagesController < ApplicationController
  before_action :logged_in_user

  def show
    @custom_css = @current_site.setting(:custom_css)
    @page = @current_site.pages.find(params[:id])
  end

end
