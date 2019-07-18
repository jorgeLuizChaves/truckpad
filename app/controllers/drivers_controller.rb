class DriversController < ApplicationController


  def index
    if params[:owner]
      drivers = Driver.owner_truck(params[:owner])
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
    render status: :not_found
  end

  def update
    Driver.transaction do
      driver = Driver.find_by(id: params[:id])
      raise DriverNotFoundError unless driver
      driver.update_attributes!(driver_params)
      render json: serializer(driver), status: :ok
    rescue => e
      render json: unprocessable_entity_errors(driver), status: :unprocessable_entity
    end

  end

  def create
    driver = Driver.new(driver_params)
    driver.save!
    render json: serializer(driver), status: :created
    rescue => e
      errors = unprocessable_entity_errors(driver)
      p e.message
      p e
      p "jorge"
      render json: errors , status: :unprocessable_entity
  end

  def destroy
    driver = Driver.find_by(id: driver_id)
    raise DriverNotFoundError unless driver
    driver.status = :INACTIVE
    driver.save!
    render status: :ok
  end

  private
  def serializer(obj, options = {})
    DriverSerializer.new(obj, options).serialized_json
  end

  def driver_id
    params[:id]
  end

  def driver_params
    params.require(:data).require(:attributes)
        .permit(:name, :age, :gender) 
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
