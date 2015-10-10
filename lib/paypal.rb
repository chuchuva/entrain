class PayPal
  def self.gateway(site)
    if site.setting(:paypal_sandbox) == 'true'
      ActiveMerchant::Billing::Base.mode = :test
    end
    paypal_options = {
      :login => site.setting(:paypal_user),
      :password => site.setting(:paypal_password),
      :signature => site.setting(:paypal_signature)
    }
    ActiveMerchant::Billing::PaypalDigitalGoodsGateway.new(paypal_options)
  end
end
