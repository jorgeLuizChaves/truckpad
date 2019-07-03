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
end
