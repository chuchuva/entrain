class Admin::AdminController < ApplicationController

  before_action :logged_in_user
  before_filter :ensure_admin
end
