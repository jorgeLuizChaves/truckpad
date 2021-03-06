class DriverLicensesController < ApplicationController

  def index
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    license = driver.driver_license
    raise DriverLicenseNotFoundError unless license
    render json: serializer(license)
  end

  def create
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    license = driver.driver_license.build(license_params)
    license.save!
    render json: license, status: :created
  rescue DriverNotFoundError => e
    render status: :bad_request
  rescue ActiveRecord::RecordInvalid => e
    render json: unprocessable_entity_errors(license), status: :unprocessable_entity
  end

  def update
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    license = driver.driver_license.find_by(id: id)
    raise DriverLicenseNotFoundError unless license
    license.update_attributes!(license_params)
    render json: serializer(license), status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: unprocessable_entity_errors(license), status: :unprocessable_entity
  end

  def destroy
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    license = driver.driver_license.find_by(id: id)
    raise DriverLicenseNotFoundError unless license
    license.disable
    license.save!
    render status: :ok
  end

  private
  def driver_id
    params[:driver_id]
  end

  def id
    params["id"]
  end

  def serializer(obj)
    DriverLicenseSerializer.new(obj).serialized_json
  end

  def license_params
    params.require(:data).require(:attributes).permit(:expiration_date,:category)
  end

  def unprocessable_entity_errors(*obj)
    errors = []
    obj.each do |model|
      if model != nil
        model.errors.messages.each_pair do |k,v|
          errors << {
              "source" => { "pointer" => "/data/attributes/#{k}" },
              "detail" => v[0]
          }
        end
      end
    end
    { 'errors' => errors}
  end
end
