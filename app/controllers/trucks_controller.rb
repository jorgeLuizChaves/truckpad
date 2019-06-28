class TrucksController < ApplicationController
  class TruckNotFound < StandardError; end
  def index
    trucks = Truck.find_by(driver_id: driver_id)
    raise TruckNotFound unless trucks
    render json: serializer(trucks)
  rescue
    render json: {}, status: :not_found
  end

  def update
    truck = Truck.find_by(id: truck_id)
    truck.update_attributes!(truck_params)
    render json: serializer(truck), status: :ok
  rescue
    render json: unprocessable_entity_errors(truck), status: :unprocessable_entity
  end

  private
  def serializer(obj)
    TruckSerializer.new(obj).serialized_json
  end

  def driver_id
    params['driver_id']
  end

  def truck_id
    params['id']
  end

  def truck_params
    params.require(:data).require(:attributes).permit(:category, :model, :brand, :is_loaded, :driver_owner)
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
