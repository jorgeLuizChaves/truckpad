class DriversController < ApplicationController
  def index
    drivers = Driver.page(page).per(per_page)
    render json: serializer(drivers)
  end

  def show
    driver = Driver.find(params[:id])
    render json: serializer(driver)
  end

  private
  def serializer(obj)
    DriverSerializer.new(obj).serialized_json
  end
end
