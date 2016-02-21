require "paypal"
require "stripe"

class OrdersController < ApplicationController
before_action :set_locale
 
  def new
    setup_new
    @order = @current_site.orders.build
    @order.program = @program

    if @installment_plans.present?
      @order.installment_plan_id = @installment_plans.first.id
    end

    @order.pay_method = :card;
    if @current_site.subdomain == "stashahealthcatalyst"
      render "new-stasha"
    end
  end

  def create
    setup_new
    @order = @current_site.orders.build(order_params)
    @order.amount = @price;
    @order.program = @program
    if params[:stripeEmail]
      @order.email = params[:stripeEmail]
    end

    if @order.invalid?
      render :new
      return
    end

    if @order.installment_plan
      @order.amount = @order.installment_plan.first_payment
    end
    
    if @order.pay_method && @order.pay_method.to_sym == :bank_transfer &&
       @current_site.setting(:bank_transfer_enabled)
      @order.submit!
      redirect_to bank_transfer_instructions_path
      return
    end
    
    if @order.pay_method && @order.pay_method.to_sym == :paypal
      paypal
      return
    end

    Stripe.api_key = @current_site.setting(:stripe_secret_key)

    customer = nil
    if @order.installment_plan && @order.installment_plan.first_payment < @price
      customer = Stripe::Customer.create(
        :email => @order.email,
        :description => @order.first_name + " " + @order.last_name,
        :source => params[:stripeToken]
      )
    end
    charge = Stripe::Charge.create(
      :customer    => customer ? customer[:id] : nil,
      :source      => customer ? nil : params[:stripeToken],
      :amount      => (@order.amount * 100).to_i, # Stripe expects cents
      :description => @program.name,
      :currency    => @current_site.currency
    )
    @order.submit!
    redirect_to thank_you_path
  rescue Stripe::CardError => e
    @order.errors[:base] << e.message
    render :new
  end

  # Sets up PayPal Express Checkout
  # Redirects to PayPal website
  def paypal
    gateway = PayPal.gateway(@current_site)
    response = gateway.setup_purchase((@order.amount * 100).to_i,
      currency:          @current_site.currency,
      ip:                request.remote_ip,
      return_url:        paypal_confirm_url,
      cancel_return_url: new_order_url,
      items:             [ { :name => @program.name,
                             :number => @program.id,
                             :quantity => "1",
                             :amount   => (@order.amount * 100).to_i,
                             :description => "" } ] 
    )

    if response.success?
      redirect_to gateway.redirect_url_for(response.token)
    else
      @order.errors[:base] << response.message
      render :new
    end
  end

  def paypal_confirm
    redirect_to action: 'new' unless params[:token]
    
    details = PayPal.gateway(@current_site).details_for(params[:token])
    if !details.success?
      return render plain: details.message
    end

    program = @current_site.programs.find(details.params["number"])
    response = PayPal.gateway(@current_site).purchase(
        (details.params["amount"].to_f * 100).to_i,
        currency:          @current_site.currency,
        ip:                request.remote_ip,
        token:             params[:token],
        payer_id:          params[:PayerID],
        items:             [ { :name => program.name,
                               :number => program.id,
                               :quantity => "1",
                               :amount   => (details.params["amount"].to_f * 100).to_i,
                               :description => "" } ] 
        )
    if !response.success?
      return render plain: response.message
    end

    order = @current_site.orders.build({
                email: details.email,
                first_name: details.params["first_name"],
                last_name: details.params["last_name"],
                amount: details.params["amount"],
                pay_method: :paypal
              })
    order.program = program;

    if !order.submit!
      return render plain: order.errors.full_messages
    end

    redirect_to thank_you_path
  end

  # /purchase/1/thank-you
  def thank_you
    @custom_css = @current_site.setting(:custom_css)
    @program = @current_site.programs.find(params[:program_id])
    @text = @program.text(:thank_you)
  end

  def bank_transfer_instructions
    @custom_css = @current_site.setting(:custom_css)
    @program = @current_site.programs.find(params[:program_id])
    @instructions = @program.text(:bank_transfer_instructions)
  end

  private
    def setup_new
      @custom_css = @current_site.setting(:custom_css)
      @program = @current_site.programs.find(params[:program_id])
      @coupon = @program.check_coupon(params[:code])
      @installment_plans = @program.installment_plans.where(
        coupon_id: @coupon).order(first_payment: :desc)
      @price = @program.apply_coupon(@coupon)
      @sales_text = @program.text(:sales)
    end

    def order_params
      params.require(:order).permit(:first_name, :last_name, :email,
        :pay_method, :installment_plan_id)
    end
    
    def set_locale
      I18n.locale = @current_site.setting(:locale) || I18n.default_locale
    end

end
