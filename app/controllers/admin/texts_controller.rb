class Admin::TextsController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_text, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/texts
  def index
    @texts = @program.texts
  end

  # GET /admin/texts/1
  def show
  end

  # GET /admin/programs/1/texts/new
  def new
    @text = @program.texts.build
  end

  # GET /admin/texts/1/edit
  def edit
  end

  # POST /admin/programs/1/texts
  def create
    @text = @program.texts.build(text_params)
    @text.site_id = @program.site_id

    if @text.save
      redirect_to admin_program_texts_url(@program), notice: 'Text was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/texts/1
  def update
    if @text.update(text_params)
      redirect_to [:admin, @text], notice: 'Text was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/texts/1
  def destroy
    program = @text.program
    @text.destroy
    redirect_to admin_program_texts_url(program),
      notice: 'Text was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_text
      @text = @current_site.texts.find(params[:id])
      @program = @text.program
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_params
      params.require(:text).permit(:text_type, :value)
    end
end
