require 'rails_helper'

RSpec.describe 'routes for rides', :type => :routing do
  driver_id = "1"

  it 'should /rides to rides_controller#report' do
    expect(get '/rides').to route_to('rides#report')
  end

  it 'should /drivers/{driver_id}/rides to rides_controller#index' do
    expect(get "/drivers/#{driver_id}/rides").to route_to('rides#index', driver_id: driver_id)
  end
end