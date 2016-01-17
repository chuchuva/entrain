class Admin::CouponsController < Admin::AdminController
  before_action :set_program, only: [:index, :new, :create]
  before_action :set_coupon, only: [:show, :edit, :update, :destroy]

  # GET /admin/programs/1/coupons
  def index
    @coupons = @program.coupons
  end

  # GET /admin/coupons/1
  def show
  end

  # GET /admin/programs/1/coupons/new
  def new
    @coupon = @program.coupons.build
  end

  # GET /admin/coupons/1/edit
  def edit
  end

  # POST /admin/programs/1/coupons
  def create
    @coupon = @program.coupons.build(coupon_params)
    @coupon.site_id = @program.site_id

    if @coupon.save
      redirect_to [:admin, @coupon], notice: 'Coupon was successfully created.'

    else
      render :new
    end
  end

  # PATCH/PUT /admin/coupons/1
  def update
    if @coupon.update(coupon_params)
      redirect_to [:admin, @coupon], notice: 'Coupon was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/coupons/1
  def destroy
    program = @coupon.program
    @coupon.destroy
    redirect_to admin_program_coupons_url(program),
      notice: 'Coupon was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = @current_site.programs.find(params[:program_id])
    end

    def set_coupon
      @coupon = @current_site.coupons.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coupon_params
      params.require(:coupon).permit(:code, :price)
    end
end
