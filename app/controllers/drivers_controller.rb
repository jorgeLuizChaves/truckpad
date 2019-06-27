class DriversController < ApplicationController

  class DriverNotFoundError < StandardError; end

  def index
    drivers = Driver.page(page).per(per_page)
    render json: serializer(drivers)
  end

  def show
    driver = Driver.find(params[:id])
    raise DriverNotFoundError unless driver
    render json: serializer(driver)
  rescue
    render json: {}, status: :not_found
  end

  def update
    p params
  end

  def create
    driver = Driver.new(driver_params)
    Driver.transaction do
      driver.save!
      driver_license = driver.driver_license.build(license_params)
      truck = driver.truck.build(truck_params)
      driver_license.save!
      truck.save!
      render json: serializer(driver), status: :created
    rescue => error
      errors = unprocessable_entity_errors(driver, driver_license, truck)
      render json: errors , status: :unprocessable_entity
    end
  end

  private
  def serializer(obj)
    DriverSerializer.new(obj).serialized_json
  end

  def driver_params
    params.require(:data).require(:attributes)
        .permit(:name, :age, :gender) 
  end

  def license_params
    params.require(:data).require(:attributes).require(:license)
        .permit(:category, :expiration_date)
  end

  def truck_params
    params.require(:data).require(:attributes).require(:truck)
      .permit(:category, :model, :brand, :is_loaded, :driver_owner)
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
