class DriverLicensesController < ApplicationController
  class DriverLicenseError < StandardError; end
  def index
    license = DriverLicense.find_by(driver_id: driver_id)
    raise DriverLicenseError unless license
    render json: serializer(license)
  rescue
    render json: {}, status: :not_found
  end

  private
  def driver_id
    params[:driver_id]
  end

  def serializer(obj)
    DriverLicenseSerializer.new(obj).serialized_json
  end
end
