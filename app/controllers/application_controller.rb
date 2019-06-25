class ApplicationController < ActionController::API

  def page
    params[:page] ? params[:page] : 1
  end

  def per_page
    params[:per] ? params[:per] : 3
  end
end
