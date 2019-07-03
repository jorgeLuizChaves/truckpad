class RidesController < ApplicationController

  def index
    driver = Driver.find_by(id:params[:driver_id])
    rides = driver.rides
    options = {}
    options[:meta] = { total: rides.count, page: page, per_page: per_page }
    render json: serializer(rides, options), status: :ok
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

  def serializer(obj, options = {})
    RideSerializer.new(obj, options).serialized_json
  end
end
