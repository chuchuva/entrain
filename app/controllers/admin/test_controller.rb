class Admin::TestController < Admin::AdminController
  def error
    raise 'This is test error to make sure that error logging works, ignore'
  end
end
