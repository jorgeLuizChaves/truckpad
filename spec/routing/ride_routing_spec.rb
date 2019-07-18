require 'rails_helper'

RSpec.describe 'routes for rides', :type => :routing do
  driver_id = "1"
  ride_id = "1"

  it 'should /rides to rides_controller#report' do
    expect(get '/rides').to route_to('rides#report')
  end

  it 'should /drivers/{driver_id}/rides to rides_controller#index' do
    expect(get "/drivers/#{driver_id}/rides").to route_to('rides#index', driver_id: driver_id)
  end

  it 'should /drivers/{driver_id}/rides to rides_controller#create' do
    expect(post "/drivers/#{driver_id}/rides").to route_to('rides#create', driver_id: driver_id)
  end

  it 'should /drivers/{driver_id}/rides/{id} to rides_controller#update' do
    expect(put "/drivers/#{driver_id}/rides/#{ride_id}").to route_to('rides#update', driver_id: driver_id, id: ride_id)
  end

  it 'should /drivers/{driver_id}/rides/{id} to rides_controller#update' do
    expect(patch "/drivers/#{driver_id}/rides/#{ride_id}").to route_to('rides#update', driver_id: driver_id, id: ride_id)
  end

  it 'should /drivers/{driver_id}/rides/{id} to rides_controller#destroy' do
    expect(delete "/drivers/#{driver_id}/rides/#{ride_id}").to route_to('rides#destroy', driver_id: driver_id, id: ride_id)
  end
end