require "rails_helper"

RSpec.describe "routes for Drivers", :type => :routing do
  it 'routes /drivers to drivers controller' do 
    expect(get '/drivers').to route_to("drivers#index")
  end

  it 'routes /drivers/{id} to drivers controller' do
    id = 1
    expect(get "drivers/#{id}").to route_to('drivers#show', id: "#{id}")
  end

  it 'routes /drivers/{id} to drivers controller' do 
    id = 1
    expect(put "drivers/#{id}").to route_to('drivers#update', id: "#{id}")
    expect(patch "drivers/#{id}").to route_to('drivers#update', id: "#{id}")
  end
end