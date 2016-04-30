class Admin::SettingsController < Admin::AdminController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  layout "admin"

  # GET admin/settings
  def index
    @settings = @current_site.site_settings
  end

  # GET admin/settings/1
  def show
  end

  # GET /settings/new
  def new
    @setting = @current_site.site_settings.build
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  def create
    @setting = @current_site.site_settings.build(setting_params)

    if @setting.save
      redirect_to admin_setting_path(@setting), notice: 'Setting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to admin_setting_path(@setting), notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /settings/1
  def destroy
    @setting.destroy
    redirect_to admin_settings_url, notice: 'Setting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = @current_site.site_settings.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:site_setting).permit(:name, :value)
    end
end
