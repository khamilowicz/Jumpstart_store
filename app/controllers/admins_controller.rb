class AdminsController < ApplicationController
  before_filter :ensure_not_guest
  
  def dashboard

  end
end