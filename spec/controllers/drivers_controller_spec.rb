require 'rails_helper'

RSpec.describe DriversController, type: :controller do

  describe "#index" do

    subject { get :index }

    it 'should return http status code 200' do
      subject
      expect(response).to have_http_status(:ok)
    end

    it 'should return proper json' do
      quantity_of_drivers = 2
      create_list :driver, quantity_of_drivers
      subject
      Driver.all.each_with_index do |driver, index|
        expect(json_data[index]['attributes']).to eq({
          'name' => driver.name,
          'age' => driver.age,
          'gender' => driver.gender
        })
      end 
    end

    context 'when we want only drivers that have a truck' do
      let(:drivers_no_truck) do
        create_list :driver, 3
      end

      let(:driver) do
        create :driver
      end

      let(:truck) do
        create :truck, driver: driver, driver_owner: true
      end
      subject{get :index, params: {owner: true}}
      it 'should return only truckers owner or not, according to the parameter' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return just one driver' do
        drivers_no_truck
        driver
        truck
        subject
        expect(json_data.count).to eq 1
      end

      it 'should have proper json' do
        drivers_no_truck
        driver
        truck
        subject
        expect(json_data[0]['attributes']).to eq({
            'name' => driver.name,
            'age' => driver.age,
            'gender' => driver.gender
        })
      end
    end
  end

  describe "#create" do
    context 'when parameters are valid' do
      subject { post :create, params: create_params_valid}

      let(:create_params_valid) do
        {
          data: {
            type: 'driver',
            attributes: {
              name: 'name',
              age: 35,
              gender: 'MALE',
              license: {
                  'category': :C,
                  'expiration_date': '2020-01-01'
              },
              truck: {
                category: :SIMPLE,
                model: 'model',
                brand: 'brand',
                is_loaded: true,
                driver_owner: true
              },
              ride: {
                  status: :IN_PROGRESS,
                  comeback_load: false,
                  origin_lat: 1.5,
                  origin_lng: 1.5,
                  destination_lat: 2.5,
                  destination_lng: 2.5
              }
            }
          }
        }
      end

      it 'should return status code 201' do
        subject
        expect(response).to have_http_status :created
      end

      it 'should return proper json' do
        subject
        expect(json_data['attributes']).to include({
            'name' => 'name',
            'age' => 35,
            'gender' => "MALE"
        })
      end

      it 'should create an driver' do
        expect{subject}.to change{Driver.count}.by 1 
      end
    end

    context 'when some parameter (driver) is invalid' do
      let(:invalid_entity_name) do
        {
            data: {
                attributes: {
                    name: '',
                    age: nil,
                    gender: nil
                }
            }
        }
      end

      let(:errors) do
        [
            {"source"=>{"pointer"=>"/data/attributes/name"}, "detail"=>"can't be blank"},
            {"source"=>{"pointer"=>"/data/attributes/age"}, "detail"=>"can't be blank"},
            {"source"=>{"pointer"=>"/data/attributes/gender"}, "detail"=>"can't be blank"}]
      end

      subject { post :create, params: invalid_entity_name}

      it 'should return http status code unprocessabe_entity' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return proper json' do
        subject
        errors.each_with_index do |error, index|
          expect(json_errors[index]).to include(error)
        end
      end
    end
  end

  describe "#show" do
    subject {get :show, params: {id:1}}

    context "when there is no driver" do
      it 'should return status code 404' do
        subject
        expect(response).to have_http_status(:not_found)
      end

      it 'should return proper json' do
        driver = create :driver
        subject
        expect(json_data['attributes']).to include({
          'name' => driver.name,
          'age' => driver.age,
          'gender' => driver.gender
        })
      end
    end
  end

  describe "#update" do
    let(:driver_update) do
      create :driver
    end

    let(:update_params_valid) do
      {
          id: driver_update.id,
          data: {
              type: 'driver',
              attributes: {
                  name: 'update',
                  age: 88,
                  gender: :FEMALE
              }
          }
      }
    end
    context 'when parameters are valid' do
      subject{put :update, params: update_params_valid}
      it 'should return status code ok' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json (driver)' do
        subject
        expect(json_data['attributes']).to include({
          'name'=> 'update',
          'age' =>88,
          'gender' =>  'FEMALE',
        })
        expect { driver_update.reload }.to change(driver_update, :updated_at)
      end
    end
    context 'when parameters are invalid' do
      let(:params) do
        {
            id: driver_update.id,
            data: {
                type: 'driver',
                attributes: {
                    name: nil,
                    age: nil,
                    gender: nil
                }
            }
        }
      end

      let(:errors) do
        [
            {"source"=>{"pointer"=>"/data/attributes/name"}, "detail"=>"can't be blank"},
            {"source"=>{"pointer"=>"/data/attributes/age"}, "detail"=>"can't be blank"},
            {"source"=>{"pointer"=>"/data/attributes/gender"}, "detail"=>"can't be blank"}
        ]
      end

      subject {put :update, params: params}

      it 'should return status code unprocessable entity' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return proper json errors' do
        subject
        errors.each_with_index do |error, index|
          expect(json_errors[index]).to include(error)
        end
      end
    end
  end

  describe "#destroy" do
    context 'when delete executes successfully' do
      let(:driver_destroy_1) do
        create :driver
      end
      subject {delete :destroy, params: {id: driver_destroy_1.id}}
      it 'should return status code ok' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should modify status to :INACTIVE' do
        subject
        expect { driver_destroy_1.reload }.to change(driver_destroy_1, :status)
      end
    end

    context 'when there is no driver to delete' do
      let(:driver_destroy_2) do
        create :driver
      end
      subject {delete :destroy, params: {id: 99}}

      it 'should return status code not_found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end
end