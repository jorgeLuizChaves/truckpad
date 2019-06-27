class DriversController < ApplicationController
  def index
    drivers = Driver.page(page).per(per_page)
    render json: serializer(drivers)
  end

  def show
    driver = Driver.find(params[:id])
    render json: serializer(driver)
  end

  def update
    p params
  end

  def create
    driver = Driver.new(driver_params)
    Driver.transaction do
      driver.save!
      driver_license = driver.driver_license.build(license_params)
      driver_license.save!
      render json: serializer(driver), status: :created
    end
  rescue
    errors = unprocessable_entity_errors(driver.errors.messages)
    render json: errors , status: :unprocessable_entity
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
    params.require(:data).require(:attributes)
        .permit(:category, :expiration_date)
  end

  def unprocessable_entity_errors(messages)
    errors = []
    messages.each_pair do |k,v|
      errors << {
          "source" => { "pointer" => "/data/attributes/#{k}" },
          "detail" => v[0]
      }
    end
    { "errors" => errors }
  end
end
