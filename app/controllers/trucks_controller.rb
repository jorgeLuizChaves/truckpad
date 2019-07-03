class TrucksController < ApplicationController
  class TruckNotFound < StandardError; end
  class DriverNotFoundError < StandardError; end
  def index
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    trucks = driver.truck
    raise TruckNotFound unless trucks
    options = {}
    options[:meta] = { total: trucks.count, page: page, per_page: per_page }
    render json: serializer(trucks, options)
  rescue => e
    render json: {}, status: :not_found
  end

  def update
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    truck = Truck.find_by(id: truck_id, driver_id: driver.id)
    truck.update_attributes!(truck_params)
    render json: serializer(truck), status: :ok
  rescue DriverNotFoundError => e
    render json: {}, status: :not_found
  rescue
    render json: unprocessable_entity_errors(truck), status: :unprocessable_entity
  end

  def report
    trucks = report_query
    options = {}
    options[:meta] = { total: trucks.count, page: page, per_page: per_page }
    render json: serializer(trucks.page(page).per(per_page), options), status: :ok
  end

  private
  def serializer(obj, options = {})
    TruckSerializer.new(obj, options).serialized_json
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

  def report_query
    trucks = Truck.where(driver_owner: params[:driver_owner])
        .or(Truck.where(category: params[:category]))
        .or(Truck.where(model: params[:model]))
        .or(Truck.where(brand: params[:brand]))
                 # .page(page).per(per_page)
    trucks = Truck.all unless trucks.count > 0
    trucks
  end
end
