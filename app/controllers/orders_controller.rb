require "stripe"

class OrdersController < ApplicationController
  def new
    @order = @current_site.orders.build
    @order.amount = 777;
    program = @current_site.programs.find(params[:program_id])
    @order.program = program;
    @stripe_publishable_key = "todo: key"
  end

  def create
    program = @current_site.programs.find(params[:program_id])
    @order = @current_site.orders.build(order_params)
    user = @current_site.find_user_by_email(params[:stripeEmail])
    if !user
      user = @current_site.users.build
      user.name = @order.first_name + " " + @order.last_name
      user.email = params[:stripeEmail]
      user.password = SecureRandom.base64
      user.password_set = false
      user.save
    end

    @order.amount = 777;
    @order.program = program;
    @order.user = user
    @order.email = params[:stripeEmail]
    @order.pay_method = :card

    Stripe.api_key = "todo: key"
    charge = Stripe::Charge.create(
      :source      => params[:stripeToken],
      :amount      => (@order.amount * 100).to_i, # Stripe expects cents
      :description => program.name,
      :currency    => 'usd'
    )
    @order.save
    redirect_to :purchase_thank_you
  rescue Stripe::CardError => e
    @order.errors[:base] << e.message
    render :new
  end

  def thank_you
  end

  private
    def order_params
      params.require(:order).permit(:first_name, :last_name)
    end
end
