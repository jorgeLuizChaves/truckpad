require 'rails_helper'

RSpec.describe RidesController, type: :controller do

  describe '#report' do
    context 'when there is ride to show' do
      subject {get :report}
      it 'should return proper http status' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        rides = create_list :ride, 3
        subject
        expect(json_data.count).to eq rides.count
        rides.each_with_index do |ride, index|
          expect(json_data[index]['attributes']).to include({
            'status' => ride.status,
            'origin_lng' => ride.origin_lng,
            'origin_lat' => ride.origin_lat,
            'destination_lng' => ride.destination_lng,
            'destination_lat' => ride.destination_lat,
          })
        end
      end
    end

    context 'when query only comeback load' do
      subject {get :report, params: {comeback_load:true}}
      it 'should return only rides without load to comeback' do
        create_list :ride, 7, comeback_load: false
        rides_with_load_comeback = create_list :ride, 9, comeback_load: true
        subject
        expect(json_meta['total']).to eq rides_with_load_comeback.count
      end
    end

    context 'when query all rides' do
      subject {get :report}
      it 'should return all rides' do
        with_load = 9
        no_load = 7
        create_list :ride, no_load, comeback_load: false
        create_list :ride, with_load, comeback_load: true
        subject
        expect(json_meta['total']).to eq (with_load + no_load)
      end
    end
  end

  describe '#index' do
    context 'when driver has rides' do
      let(:driver_with_rides) do
        create :driver
      end
      subject {get :index, params: {driver_id:driver_with_rides.id}}
      it 'should return proper json' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        rides_count = 9
        rides = create_list :ride, rides_count, driver: driver_with_rides
        subject
        expect(json_data.count).to eq rides.count
        rides.each_with_index do |ride, index|
          expect(json_data[index]['attributes']).to include({
            'status' => ride.status,
            'origin_lng' => ride.origin_lng,
            'origin_lat' => ride.origin_lat,
            'destination_lng' => ride.destination_lng,
            'destination_lat' => ride.destination_lat,
          })
        end
      end

      it 'should return total rides' do
        rides_count = 9
        rides = create_list :ride, rides_count, driver: driver_with_rides
        subject
        expect(json_meta['total']).to eq rides.count
      end
    end
  end

  describe '#create' do
    context 'when create with success' do
      let(:driver) do
        create :driver
      end

      let(:params) do
        {
          driver_id: driver.id,
          data: {
            attributes: {
                origin: 'Google Office SP',
                origin_lat: -23.5477866,
                origin_lng: -46.6852194,
                destination: 'Google Office NY',
                destination_lat: 40.742131,
                destination_lng: -74.0071718,
                comeback_load: true
            }
          }
        }
      end

      subject {post :create, params: params}

      it 'should return status code 201' do
        subject
        expect(response).to have_http_status :created
      end

      it 'should return proper json' do
        subject
        expect(json_data['attributes']).to include({
            'origin_lat' => -23.5477866,
            'origin_lng' => -46.6852194,
            'destination_lat' => 40.742131,
            'destination_lng' => -74.0071718,
            'comeback_load' => true,
            'status' => 'CREATED'
        })
      end
    end

    context 'when driver is not found' do

      let(:params) do
        {
            driver_id: 99,
            data: {
                attributes: {

                }
            }
        }
      end
      subject {post :create, params: params}

      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when ride is invalid' do
      let(:driver) do
        create :driver
      end

      let(:params) do
        {
            driver_id: driver.id,
            data: {
                attributes: {
                    origin: 'Google Office SP',
                    origin_lat: nil,
                    origin_lng: nil,
                    destination: nil,
                    destination_lat: nil,
                    destination_lng: nil,
                    comeback_load: true
                }
            }
        }
      end

      let(:errors) do
        [{"detail"=>"can't be blank",
          "source"=>{"pointer"=>"/data/attributes/origin_lat"}},
         {"detail"=>"can't be blank",
          "source"=>{"pointer"=>"/data/attributes/origin_lng"}},
         {"detail"=>"can't be blank",
          "source"=>{"pointer"=>"/data/attributes/destination_lat"}},
         {"detail"=>"can't be blank",
          "source"=>{"pointer"=>"/data/attributes/destination_lng"}}]

      end

      subject {post :create, params: params}

      it 'should return status code 422' do
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

  describe '#update' do

    context 'when update success' do
      let(:driver){create :driver}
      let(:ride){create :ride, driver: driver}
      let(:params)do
        {
            driver_id: driver.id,
            id: ride.id,
            data:{
                attributes:{
                    origin_lat: 0,
                    origin_lng: 0,
                    destination: 'Google Office NY',
                    destination_lat: 0,
                    destination_lng: 0,
                    comeback_load: true
                }
            }
        }
      end

      subject{put :update, params:params}
      it 'should return status code 200' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should return proper json' do
        subject
        expect(json_data['attributes']).to include({
             'origin_lat' => 0.0,
             'origin_lng' => 0.0,
             'destination_lat' => 0.0,
             'destination_lng' => 0.0,
             'comeback_load' => true,
             'status' => 'CREATED'
         })
      end
    end

    context 'when driver is invalid' do
      let(:params)do
        {
            driver_id: 99,
            id: 99,
            data:{
                attributes:{
                    origin_lat: 0,
                    origin_lng: 0,
                    destination: 'Google Office NY',
                    destination_lat: 0,
                    destination_lng: 0,
                    comeback_load: true
                }
            }
        }
      end

      subject{put :update, params:params}
      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when ride is invalid' do
      let(:driver){create :driver}
      let(:params)do
        {
            driver_id: driver.id,
            id: 99,
            data:{
                attributes:{
                    origin_lat: 0,
                    origin_lng: 0,
                    destination: 'Google Office NY',
                    destination_lat: 0,
                    destination_lng: 0,
                    comeback_load: true
                }
            }
        }
      end

      subject{put :update, params:params}
      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when update error' do
      let(:driver){create :driver}
      let(:ride){create :ride, driver: driver}
      let(:params)do
        {
            driver_id: driver.id,
            id: ride.id,
            data:{
                attributes:{
                    origin_lat: nil,
                    origin_lng: nil,
                    destination: nil,
                    destination_lat: nil,
                    destination_lng: nil,
                    comeback_load: true
                }
            }
        }
      end

      let(:errors) do
        [{"detail"=>"can't be blank",
           "source"=>{"pointer"=>"/data/attributes/origin_lat"}},
        {"detail"=>"can't be blank",
           "source"=>{"pointer"=>"/data/attributes/origin_lng"}},
        {"detail"=>"can't be blank",
           "source"=>{"pointer"=>"/data/attributes/destination_lat"}},
        {"detail"=>"can't be blank",
           "source"=>{"pointer"=>"/data/attributes/destination_lng"}}]
      end

      subject{put :update, params:params}
      it 'should return status code 422' do
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

  describe '#delete' do
    context 'when destroy success' do
      let(:driver){create :driver}
      let(:ride){create :ride, driver: driver}
      let(:params) do
        {
            driver_id: driver.id,
            id: ride.id
        }
      end

      subject {delete :destroy, params: params}

      it 'should return status code 200' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should update ride' do
        subject
        expect { ride.reload }.to change(ride, :status)
      end
    end

    context 'when driver is invalid' do
      let(:params) do
        {
            driver_id: 99,
            id: 99
        }
      end

      subject {delete :destroy, params: params}

      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when ride is invalid' do
      let(:driver){create :driver}
      let(:ride){create :ride, driver: driver}
      let(:params) do
        {
            driver_id: driver.id,
            id:99,
        }
      end

      subject {delete :destroy, params: params}

      it 'should return status code 404' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end
end