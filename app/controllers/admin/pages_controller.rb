class Admin::PagesController < ApplicationController
  before_action :logged_in_user
  before_action :set_program
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/pages
  def index
    @pages = @current_site.programs.find(params[:program_id]).pages
  end

  # GET /admin/programs/1/pages/1
  def show
  end

  # GET /admin/programs/1/pages/new
  def new
    @page = @program.pages.build
  end

  # GET /admin/programs/1/pages/1/edit
  def edit
  end

  # POST /admin/programs/1/pages
  def create
    @page = @program.pages.build(page_params)
    @page.site_id = @program.site_id

    if @page.save
      redirect_to [:admin, @program, @page], notice: 'Page was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/programs/1/pages/1
  def update
    if @page.update(page_params)
      redirect_to [:admin, @program, @page], notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/programs/1/pages/1
  def destroy
    @page.destroy
    redirect_to admin_program_pages_url(@program), notice: 'Page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = @current_site.programs.find(params[:program_id])
    end

    def set_page
      @page = @program.pages.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:slug, :title, :content)
    end
end
