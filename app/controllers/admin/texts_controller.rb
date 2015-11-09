class Admin::TextsController < ApplicationController
  before_action :logged_in_user
  before_action :set_program
  before_action :set_text, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/texts
  def index
    @texts = @program.texts
  end

  # GET /admin/programs/1/texts/1
  def show
  end

  # GET /admin/programs/1/texts/new
  def new
    @text = @program.texts.build
  end

  # GET /admin/programs/1/texts/1/edit
  def edit
  end

  # POST /admin/programs/1/texts
  def create
    @text = @program.texts.build(text_params)
    @text.site_id = @program.site_id

    if @text.save
      redirect_to [:admin, @program, @text], notice: 'Text was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/programs/1/texts/1
  def update
    if @text.update(text_params)
      redirect_to [:admin, @program, @text], notice: 'Text was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/programs/1/texts/1
  def destroy
    @text.destroy
    redirect_to admin_program_texts_url(@program), notice: 'Text was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = @current_site.programs.find(params[:program_id])
    end

    def set_text
      @text = @program.texts.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def text_params
      params.require(:text).permit(:text_type, :value)
    end
end