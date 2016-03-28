class Admin::InstallmentPlansController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_installment_plan, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/installment_plans
  def index
    @installment_plans = @program.installment_plans
  end

  # GET /admin/installment_plans/1
  def show
  end

  # GET /admin/programs/1/installment_plans/new
  def new
    @installment_plan = @program.installment_plans.build
  end

  # GET /admin/installment_plans/1/edit
  def edit
  end

  # POST /admin/programs/1/installment_plans
  def create
    @installment_plan = @program.installment_plans.build(installment_plan_params)
    @installment_plan.site_id = @program.site_id

    if @installment_plan.save
      redirect_to [:admin, @installment_plan],
        notice: 'Installment plan was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/installment_plans/1
  def update
    if @installment_plan.update(installment_plan_params)
      redirect_to [:admin, @installment_plan], notice: 'Installment plan was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/installment_plans/1
  def destroy
    program = @installment_plan.program
    @installment_plan.destroy
    redirect_to admin_program_installment_plans_url(program),
      notice: 'Installment plan was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_installment_plan
      @installment_plan = @current_site.installment_plans.find(params[:id])
      @program = @installment_plan.program
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def installment_plan_params
      params.require(:installment_plan).permit(:first_payment, :description,
                                               :coupon_id)
    end
end
