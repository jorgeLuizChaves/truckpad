require 'rails_helper'

RSpec.describe 'routes for trucks', :type => :routing do
  truck_id = 1
  driver_id = 1

  it 'should /drivers/{id}/truck to trucks_controller#index' do
    expect(get "/drivers/#{driver_id}/trucks").to route_to('trucks#index', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{drive_id}/truck to trucks_controller#create' do
    expect(post "/drivers/#{driver_id}/trucks").to route_to('trucks#create', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{drive_id}/truck to trucks_controller#update' do

    expect(put "/drivers/#{driver_id}/trucks/#{truck_id}").to route_to('trucks#update', driver_id: "#{driver_id}", id: "#{truck_id}")
  end

  it 'should /drivers/{drive_id}/truck/{id} to trucks_controller#destroy' do
    expect(delete "/drivers/#{driver_id}/trucks/#{truck_id}").to route_to('trucks#destroy', driver_id: "#{driver_id}", id: "#{truck_id}")
  end

  it 'should /trucks' do
    expect(get '/trucks').to route_to('trucks#report')
  end
end