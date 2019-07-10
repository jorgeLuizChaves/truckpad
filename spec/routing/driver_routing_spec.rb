require "rails_helper"

RSpec.describe "routes for Drivers", :type => :routing do
  id = 1
  it 'routes /drivers to drivers_controller#index' do 
    expect(get '/drivers').to route_to("drivers#index")
  end

  it 'routes /drivers/{id} to drivers_controller#show' do
    expect(get "drivers/#{id}").to route_to('drivers#show', id: "#{id}")
  end

  it 'routes /drivers/{id} to drivers_controller#update' do 
    expect(put "drivers/#{id}").to route_to('drivers#update', id: "#{id}")
    expect(patch "drivers/#{id}").to route_to('drivers#update', id: "#{id}")
  end

  it 'routes /drivers to drivers_controller#create' do 
    expect(post "drivers").to route_to('drivers#create')
  end

  it 'routes /drivers/{id} to drivers_controller#destroy' do
    expect(delete "/drivers/#{id}").to route_to('drivers#destroy', id: "#{id}")
  end
end