class PayPal
  def self.gateway(site)
    paypal_options = {
      :test => site.setting(:paypal_sandbox) == 'true',
      :login => site.setting(:paypal_user),
      :password => site.setting(:paypal_password),
      :signature => site.setting(:paypal_signature)
    }
    ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end
