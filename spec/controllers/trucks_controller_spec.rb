require 'rails_helper'

RSpec.describe TrucksController, type: :controller do
  describe "#show" do
    context 'when truck is not found' do
      let(:driver) do
        create :driver
      end

      let(:truck) do
        create :truck, driver: driver
      end
      invalid_id = 9999
      subject {get :index, params: {driver_id: invalid_id}}

      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when driver has a truck' do
      let(:driver_with_car) do
        create :driver
      end

      let(:truck_owner) do
        create :truck, driver: driver_with_car
      end
      subject {get :index, params: {driver_id: driver_with_car.id}}
      it 'should return status code 200' do
        truck_owner
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        driver_with_car
        truck_owner
        subject
        expect(json_data[0]['attributes']).to include({
            'category' => truck_owner.category,
            'model' => truck_owner.model,
            'brand' => truck_owner.brand,
            'driver_owner' => truck_owner.driver_owner,
            'is_loaded' => truck_owner.is_loaded
        })
      end
    end
  end
  describe "#create" do
    let(:driver) do
      create :driver
    end
    context 'when is successful' do
      let(:truck) do
        {
            driver_id: driver.id,
            data: {
                attributes: {
                    category: :TOCO,
                    model: 'model',
                    brand: 'brand',
                    is_loaded: true,
                    driver_owner: true
                }
            }
        }
      end
      subject {post :create, params: truck}
      it 'should return status code created' do
        subject
        expect(response).to have_http_status :created
      end

      it 'should return proper json' do
        subject
        expect(json_data['attributes']).to include({
          'category' => 'TOCO',
          'model' => 'model',
          'brand' => 'brand',
          'is_loaded' => true,
          'driver_owner' => true
        })
      end
    end

    context 'when is invalid request' do
      let(:params) do
        {
            driver_id: driver.id,
            data: {
                attributes: {
                    category: nil,
                    model: nil,
                    brand: nil,
                    is_loaded: nil,
                    driver_owner: nil
                }
            }
        }
      end

      let(:errors) do
        [
            {"detail" => "can't be blank", "source" => {"pointer" => "/data/attributes/category"}},
            {"detail" => "is not included in the list", "source" => {"pointer" => "/data/attributes/driver_owner"}}
        ]
      end

      subject {post :create, params: params}

      it 'should return status code unprocessable entity' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return proper json' do
        subject
        errors.each_with_index { |error, index|
          expect(json_errors[index]).to include(error)
        }

      end
    end

    context 'when driver is invalid' do
      let(:params) do
        {
            driver_id: 99,
            data: {
                attributes: {
                    category: :TOCO,
                    model: 'model',
                    brand: 'brand',
                    is_loaded: true,
                    driver_owner: true
                }
            }
        }
      end
      subject {post :create, params: params}
      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end
  describe "#destroy" do
    let(:driver) do
      create :driver
    end

    let(:truck) do
      create :truck, driver: driver
    end

    context 'when request is successful' do
      let(:params) do
        {
            driver_id: driver.id,
            id: truck.id
        }
      end

      subject {delete :destroy, params: params}
      it 'should return status code ok' do
        subject
        expect(response).to have_http_status :ok
      end
    end
    context 'when driver is invalid' do
      let(:params) do
        {
            driver_id: 99,
            id: truck.id
        }
      end

      subject {delete :destroy, params: params}

      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
    context 'when truck is invalid' do
      let(:params) do
        {
            driver_id: driver.id,
            id: 99
        }
      end

      subject {delete :destroy, params: params}
      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
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
