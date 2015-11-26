class AdminMailer < ActionMailer::Base
  default from: "Entrain Server <server@entrainhq.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_order.subject
  #
  def new_order(order)
    @current_site = order.site
    @order = order

    mail to: @current_site.admins.pluck(:email), subject: 
      "New order from #{order.first_name} #{order.last_name}"
  end
end
