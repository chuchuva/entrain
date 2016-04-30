class Admin::AdminController < ApplicationController
  layout 'admin_program'
  before_action :logged_in_user
  before_filter :ensure_admin
end
