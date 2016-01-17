class Admin::EmailTemplatesController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/email_templates
  def index
    @email_templates = @program.email_templates
  end

  # GET /admin/email_templates/1
  def show
  end

  # GET /admin/programs/1/email_templates/new
  def new
    @email_template = @program.email_templates.build
  end

  # GET /admin/email_templates/1/edit
  def edit
  end

  # POST /admin/programs/1/email_templates
  def create
    @email_template = @program.email_templates.build(email_template_params)
    @email_template.site_id = @program.site_id

    if @email_template.save
      redirect_to [:admin, @email_template],
        notice: 'Email template was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/email_templates/1
  def update
    if @email_template.update(email_template_params)
      redirect_to [:admin, @email_template],
        notice: 'Email template was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/email_templates/1
  def destroy
    program = @email_template.program
    @email_template.destroy
    redirect_to admin_program_email_templates_url(program),
      notice: 'Email template was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = @current_site.programs.find(params[:program_id])
    end

    def set_email_template
      @email_template = @current_site.email_templates.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_template_params
      params.require(:email_template).permit(:email_type, :subject, :body)
    end
end
