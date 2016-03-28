class Admin::ProgramModulesController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_program_module, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/modules
  def index
    @program_modules = @program.program_modules.order(:title)
  end

  # GET /admin/modules/1
  def show
  end

  # GET /admin/programs/1/modules/new
  def new
    @program_module = @program.program_modules.build
  end

  # GET /admin/program_modules/1/edit
  def edit
  end

  # POST /admin/programs/1/program_modules
  def create
    @program_module = @program.program_modules.build(program_module_params)
    @program_module.site_id = @program.site_id
    if @program_module.save
      redirect_to [:admin, @program_module], notice: 'Module was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/program_modules/1
  def update
    if @program_module.update(program_module_params)
      redirect_to [:admin, @program_module],
        notice: 'Module was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/program_modules/1
  def destroy
    program = @program_module.program
    @program_module.destroy
    redirect_to admin_program_program_modules_url(program),
      notice: 'Module was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program_module
      @program_module = @current_site.program_modules.find(params[:id])
      @program = @program_module.program
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_module_params
      params.require(:program_module).permit(:title, :content)
    end
end
