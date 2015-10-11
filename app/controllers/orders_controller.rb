require "paypal"
require "stripe"

class OrdersController < ApplicationController
  def new
    @custom_css = @current_site.setting(:custom_css)
    @program = @current_site.programs.find(params[:program_id])
    @order = @current_site.orders.build
    @order.program = @program;
    @order.amount = 777;
    @order.pay_method = :card;
    if @current_site.subdomain == "stashahealthcatalyst"
      render "new-stasha"
    end
  end

  def create
    @program = @current_site.programs.find(params[:program_id])
    @order = @current_site.orders.build(order_params)
    @order.amount = 777;
    @order.program = @program;
    if params[:stripeEmail]
      @order.email = params[:stripeEmail]
    end
    
    if @order.pay_method && @order.pay_method.to_sym == :paypal
      paypal
      return
    end

    Stripe.api_key = @current_site.setting(:stripe_secret_key)
    charge = Stripe::Charge.create(
      :source      => params[:stripeToken],
      :amount      => (@order.amount * 100).to_i, # Stripe expects cents
      :description => @program.name,
      :currency    => 'usd'
    )
    @order.create!
    redirect_to :purchase_thank_you
  rescue Stripe::CardError => e
    @order.errors[:base] << e.message
    render :new
  end

  # Sets up PayPal Express Checkout
  # Redirects to PayPal website
  def paypal()
    gateway = PayPal.gateway(@current_site)
    response = gateway.setup_purchase(77700,
      :ip                => request.remote_ip,
      :return_url        => paypal_confirm_url,
      :cancel_return_url => new_order_url,
      :items             => [ { :name => @program.name,
                                :number => @program.id,
                                :quantity => "1",
                                :amount   => 77700,
                                :description => "",
                                :category => "Digital" } ] 
    )
    redirect_to gateway.redirect_url_for(response.token)
  end

  def paypal_confirm
    redirect_to action: 'new' unless params[:token]
    
    details = PayPal.gateway(@current_site).details_for(params[:token])
    if !details.success?
      return render plain: details.message
    end
    program = @current_site.programs.find(details.params["number"])
    order = @current_site.orders.build({
                email: details.email,
                first_name: details.params["first_name"],
                last_name: details.params["last_name"],
                amount: details.params["amount"]
              })
    order.program = program;
    order.create!
    redirect_to :purchase_thank_you
  end

  def thank_you
    @custom_css = @current_site.setting(:custom_css)
  end

  private
    def order_params
      params.require(:order).permit(:first_name, :last_name, :email, :pay_method)
    end
end
