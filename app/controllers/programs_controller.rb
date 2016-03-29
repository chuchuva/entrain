class ProgramsController < ApplicationController
  before_action :logged_in_user
  def index
    @programs = current_user.programs
    if @programs.empty?
      render :no_access and return
    elsif @programs.count == 1
      redirect_to @programs.first and return
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
