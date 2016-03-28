class Admin::UploadsController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_upload, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/uploads
  def index
    @uploads = @program.uploads.order(:file_name)
  end

  # GET /admin/uploads/1
  def show
  end

  # GET /admin/programs/1/uploads/new
  def new
    @upload = @program.uploads.build
  end

  # GET /admin/uploads/1
  def show
  end

  # POST /admin/programs/1/uploads
  def create
    @upload = @program.uploads.build(upload_params)
    @upload.site_id = @program.site_id
    @upload.file_name = params[:filename]
    @upload.size = params[:filesize]
    @upload.save
  end

  # PATCH/PUT /admin/uploads/1
  def update
    if @upload.update(upload_params)
      redirect_to admin_program_uploads_url(@upload.program),
        notice: 'upload was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/uploads/1
  def destroy
    program = @upload.program
    @upload.destroy
    redirect_to admin_program_uploads_url(program),
      notice: 'upload was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = @current_site.uploads.find(params[:id])
      @program = @upload.program
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_params
      params.require(:upload).permit(:url)
    end
end
