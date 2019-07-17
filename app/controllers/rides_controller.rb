class RidesController < ApplicationController

  def index
    driver = Driver.find_by(id:driver_id)
    rides = driver.rides
    options = {}
    options[:meta] = { total: rides.count, page: page, per_page: per_page }
    render json: serializer(rides, options), status: :ok
  end

  def create
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    ride = driver.rides.build(ride_params)
    ride.save!
    render json: serializer(ride), status: :created
  rescue ActiveRecord::RecordInvalid
    render json: unprocessable_entity_errors(ride) , status: :unprocessable_entity
  end

  def update
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    ride = driver.rides.find_by(ride_id)
    raise RideNotFoundError unless ride
    ride.update_attributes!(ride_params)
    render json: serializer(ride), status: :ok
  rescue ActiveRecord::RecordInvalid
    render json: unprocessable_entity_errors(ride), status: :unprocessable_entity
  end

  def destroy
    driver = Driver.find_by(id: driver_id)
    raise  DriverNotFoundError unless driver
    ride = driver.rides.find_by(id: ride_id)
    raise RideNotFoundError  unless ride
    ride.status = :CANCELLED
    ride.save!
    render status: :ok
  end

  def report
    if params[:comeback_load]
      rides = Ride.where(comeback_load: params[:comeback_load])
    else
      rides = Ride.all
    end
    options = {}
    options[:meta] = { total: rides.count, page: page, per_page: per_page }
    render json: serializer(rides.page(page).per(per_page), options), status: :ok
  end

  private

  def driver_id
    params[:driver_id]
  end

  def ride_id
    params[:id]
  end

  def serializer(obj, options = {})
    RideSerializer.new(obj, options).serialized_json
  end

  def ride_params
    params.require(:data)
        .require(:attributes)
        .permit(:status, :comeback_load, :origin, :origin_lat,
                :origin_lng, :destination,:destination_lat, :destination_lng)
  end
end
