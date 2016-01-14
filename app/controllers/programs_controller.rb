class ProgramsController < ApplicationController
  before_action :logged_in_user
  def index
    program = @current_site.programs.first
    
    return redirect_to program_path(id: 6) if program.id == 5
    redirect_to program if program
  end

  def show
    @custom_css = @current_site.setting(:custom_css)
    @program = @current_site.programs.find(params[:id])
  end

  private
    # Before filters

end
