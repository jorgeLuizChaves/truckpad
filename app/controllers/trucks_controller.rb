class TrucksController < ApplicationController
  class TruckNotFound < StandardError; end
  def index
    trucks = Truck.find_by(driver_id: driver_id)
    raise TruckNotFound unless trucks
    render json: serializer(trucks)
  rescue
    render json: {}, status: :not_found
  end

  private
  def serializer(obj)
    TruckSerializer.new(obj).serialized_json
  end

  def driver_id
    params['driver_id']
  end
end
