class DriverLicensesController < ApplicationController
  def index
    license = DriverLicense.find_by(driver_id: driver_id)
    render json: serializer(license)
  end

  private
  def driver_id
    params[:driver_id]
  end

  def serializer(obj)
    DriverLicenseSerializer.new(obj).serialized_json
  end
end
