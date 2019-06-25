require 'rails_helper'

RSpec.describe '', :type => :routing do
  it 'should /drivers/{id}/truck to trucks_controller#index' do
    driver_id = 1
    expect(get "/drivers/#{driver_id}/trucks").to route_to('trucks#index', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{drive_id}/truck to trucks_controller#create' do
    driver_id = 1
    expect(post "/drivers/#{driver_id}/trucks").to route_to('trucks#create', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{drive_id}/truck to trucks_controller#update' do
    driver_id = 1
    truck_id = 1
    expect(put "/drivers/#{driver_id}/trucks/#{truck_id}").to route_to('trucks#update', driver_id: "#{driver_id}", id: "#{truck_id}")
  end
end