class ProgramsController < ApplicationController
  before_action :logged_in_user
  def index
    program = current_user.programs.first
    if program 
      redirect_to program
    else
      render :no_access
    end
  end

  def show
    @custom_css = @current_site.setting(:custom_css)
    @program = @current_site.programs.find(params[:id])
    ensure_program_access(@program)
  end

  private
    # Before filters

end
