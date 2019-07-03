class DriversController < ApplicationController

  class DriverNotFoundError < StandardError; end

  def index
    if params[:owner]
      drivers = Driver.owner_truck(params[:owner]).page(page).per(per_page)
    else
      drivers = Driver.all
    end
    options = {}
    options[:meta] = { total: drivers.count, page: page, per_page: per_page }
    render json: serializer(drivers.page(page).per(per_page), options)
  end

  def show
    driver = Driver.find(params[:id])
    raise DriverNotFoundError unless driver
    render json: serializer(driver)
  rescue
    render json: {}, status: :not_found
  end

  def update
    Driver.transaction do
      driver = Driver.find_by(id: params[:id])
      driver.update_attributes!(driver_params)

      truck = driver.truck.find_by(id: truck_id)
      truck.update_attributes!(truck_params)

      license = driver.driver_license.find_by(id: license_id)
      license.update_attributes!(license_params)

      ride = driver.rides.find_by(id: ride_id)
      ride.update_attributes!(ride_params)

      render json: serializer(driver), status: :ok
    rescue => e
      p e.message
      render json: {}, status: :unprocessable_entity
    end

  end

  def create
    driver = Driver.new(driver_params)
    Driver.transaction do
      driver.save!
      driver_license = driver.driver_license.build(license_params)
      truck = driver.truck.build(truck_params)
      driver_license.save!
      truck.save!
      ride = driver.rides.build ride_params
      ride.save!
      render json: serializer(driver), status: :created
    rescue => error
      errors = unprocessable_entity_errors(driver, driver_license, truck, ride)
      render json: errors , status: :unprocessable_entity
    end
  end

  private
  def serializer(obj, options = {})
    DriverSerializer.new(obj, options).serialized_json
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

  def ride_params
    params.require(:data).require(:attributes).require(:ride)
      .permit(:status, :comeback_load, :origin_lat, :origin_lng, :destination_lat, :destination_lng)
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

  def truck_id
    params[:data][:attributes][:truck][:id]
  end

  def license_id
    params[:data][:attributes][:license][:id]
  end

  def ride_id
    params[:data][:attributes][:ride][:id]
  end
end
