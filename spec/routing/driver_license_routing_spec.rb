require 'rails_helper'

RSpec.describe 'routes for Driver License', :type => :routing do
  driver_id = 1
  license_id = 1

  it 'should /drivers/{id}/licenses to driver_licenses_controller#index' do
    expect(get "/drivers/#{driver_id}/licenses").to route_to('driver_licenses#index', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{id}/licenses to driver_licenses_controller#create' do
    expect(post "/drivers/#{driver_id}/licenses").to route_to('driver_licenses#create', driver_id: "#{driver_id}")
  end

  it 'should /drivers/{id}/licenses to driver_licenses_controller#index' do
    expect(put "/drivers/#{driver_id}/licenses/#{license_id}").to route_to('driver_licenses#update', driver_id: "#{driver_id}", id: "#{license_id}")
  end

  it 'should /drivers/{driver_id}/licenses/{id}' do
    expect(delete "/drivers/#{driver_id}/licenses/#{license_id}").to route_to('driver_licenses#destroy', driver_id: "#{driver_id}", id: "#{license_id}")
  end
end