class ProgramModulesController < ApplicationController
  before_action :logged_in_user

  def show
    @custom_css = @current_site.setting(:custom_css)
    @program_module = @current_site.program_modules.find(params[:id])
    ensure_program_access(@program_module.program)
  end

end
