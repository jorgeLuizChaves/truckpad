require 'rails_helper'

RSpec.describe 'routes for Driver License', :type => :routing do
  it 'should /drivers/{id}/licenses to driver_licenses_controller#index' do
    driver_id = 1
    expect(get "/drivers/#{driver_id}/licenses").to route_to('driver_licenses#index', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{id}/licenses to driver_licenses_controller#create' do
    driver_id = 1
    expect(post "/drivers/#{driver_id}/licenses").to route_to('driver_licenses#create', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{id}/licenses to driver_licenses_controller#index' do
    driver_id = 1
    license_id = 1
    # expect(patch "/drivers/#{driver_id}/licenses").to route_to('driver_licenses#update', driver_id: "#{driver_id}")
    expect(put "/drivers/#{driver_id}/licenses/#{license_id}").to route_to('driver_licenses#update', driver_id: "#{driver_id}", id: "#{license_id}")
  end
end