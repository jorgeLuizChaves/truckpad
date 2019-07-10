class ApplicationController < ActionController::API
  class DriverLicenseNotFoundError < StandardError; end
  class DriverNotFoundError < StandardError; end
  class TruckNotFoundError < StandardError; end

  rescue_from ApplicationController::DriverLicenseNotFoundError, with: :license_not_found
  rescue_from ApplicationController::DriverNotFoundError, with: :driver_not_found
  rescue_from ApplicationController::TruckNotFoundError, with: :truck_not_found

  def page
    params[:page] ? params[:page] : 1
  end

  def per_page
    params[:per] ? params[:per] : 3
  end

  def license_not_found
    render status: :not_found
  end

  def driver_not_found
    render status: :not_found
  end

  def truck_not_found
    render status: :not_found
  end
end
