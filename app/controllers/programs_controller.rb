class ProgramsController < ApplicationController
  before_action :logged_in_user
  def index
    program = @current_site.programs.first
    redirect_to program if program
  end

  def show
    @program = @current_site.programs.find(params[:id])
  end

  private
    # Before filters

end
