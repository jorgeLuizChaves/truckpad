require 'rails_helper'

RSpec.describe TrucksController, type: :controller do
  describe "#show" do
    subject {get :index, params: {driver_id: 1}}
    context 'when truck is not found' do
      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when driver has a truck' do
      it 'should return status code 200' do
        driver = create :driver
        create :truck, driver: driver
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        driver = create :driver
        truck = create :truck, driver: driver
        subject
        expect(json_data['attributes']).to include({
            'category' => truck.category,
            'model' => truck.model,
            'brand' => truck.brand,
            'driver_owner' => truck.driver_owner,
            'is_loaded' => truck.is_loaded
        })
      end
    end
  end
end
