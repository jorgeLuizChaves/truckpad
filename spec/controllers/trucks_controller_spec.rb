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
  describe "#update" do
    let(:driver) do
      create :driver
    end

    let(:truck) do
      create :truck, driver: driver
    end

    let(:json_truck_update) do
      {
          driver_id: driver.id,
          id: truck.id,
          data: {
              attributes: {
                  category: 'TOCO',
                  model: 'model 2',
                  brand: 'brand 2',
                  is_loaded: 'true',
                  driver_owner: 'true'
              }
          }
      }
    end

    let(:json_truck_update_fail) do
      {
          driver_id: driver.id,
          id: truck.id,
          data: {
              attributes: {
                  category: nil,
                  model: 'model 2',
                  brand: 'brand 2',
                  is_loaded: 'true',
                  driver_owner: 'true'
              }
          }
      }
    end

    let(:json_truck_update_invalid_field_fail) do
      {
          driver_id: driver.id,
          id: truck.id,
          data: {
              attributes: {
                  category: :ABC,
                  model: 'model 2',
                  brand: 'brand 2',
                  is_loaded: 'true',
                  driver_owner: 'true'
              }
          }
      }
    end

    let(:json_truck_invalid_user) do
      {
          driver_id: 99,
          id: truck.id,
          data: {
              attributes: {
                  category: :ABC,
                  model: 'model 2',
                  brand: 'brand 2',
                  is_loaded: 'true',
                  driver_owner: 'true'
              }
          }
      }
    end

    context 'when update success' do
      subject {patch :update, params: json_truck_update}
      it 'should return http status :ok' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        subject
        expect(json_data['attributes']).to include({
            'model' => 'model 2',
            'brand' => 'brand 2',
            'category' => 'TOCO',
            'is_loaded' => true,
            'driver_owner' => true
        })

      end
    end
    context 'when update fails' do
      subject {put :update, params: json_truck_update_fail}
      it 'should return status code 422' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return proper json' do
        subject
        expect(json_errors).to include({
            "source" => { "pointer" => "/data/attributes/category" },
            "detail" => "can't be blank"
        })
      end
    end
    context 'when update has invalid fields' do
      subject {put :update, params: json_truck_update_invalid_field_fail}
      it 'should return status code 422' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return proper json' do
        subject
        expect(json_errors).to include({
            "source" => { "pointer" => "/data/attributes/category" },
            "detail" => "This truck category isn't valid"
        })
      end
    end
    context 'when user is invalid' do
      subject {put :update, params: json_truck_invalid_user}
      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end
  describe "#report" do
    let(:truck_list) do
      create_list :truck, 3
    end

    context 'when is doing a report without params' do
      subject{get :report}
      it 'should return proper http status code 200' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        truck_list
        subject
        expect(json_data.count).to eq(truck_list.count)
      end
    end

    context 'when is doing a report with params' do
      subject{get :report, params: {driver_owner:true}}
      it 'should return proper http status code 200' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        truck_list
        driver_count = 1
        create_list :truck, driver_count, driver_owner: true
        subject
        expect(json_data.count).to eq(driver_count)
        expect(json_data[0]['attributes']).to include({
          "brand" => "brand",
          "category" => "SIMPLE",
          "driver_owner" => true,
          "is_loaded" => false,
          "model" => "model"
        })
      end
    end
  end
end
