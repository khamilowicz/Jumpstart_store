class AdminsController < ApplicationController
  # before_filter :ensure_not_guest
  before_filter :authorize_admin
  
  def dashboard
  end
end