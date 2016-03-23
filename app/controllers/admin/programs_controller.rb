class Admin::ProgramsController < Admin::AdminController
  before_action :set_program, only: [:show, :edit, :update, :destroy]
  layout "admin", except: [:index, :new]

  # GET admin/programs
  def index
    @programs = @current_site.programs
  end

  # GET admin/programs/1
  def show
  end

  # GET /programs/new
  def new
    @program = @current_site.programs.build
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs
  def create
    @program = @current_site.programs.build(program_params)

    if @program.save
      redirect_to [:admin, @program], notice: 'Program was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /programs/1
  def update
    if @program.update(program_params)
      redirect_to [:admin, @program], notice: 'Program was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /programs/1
  def destroy
    @program.destroy
    redirect_to admin_programs_url, notice: 'Program was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = @current_site.programs.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def program_params
      params.require(:program).permit(:name, :slug, :price, :content)
    end
end
