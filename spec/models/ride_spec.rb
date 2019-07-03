require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe '#validate' do
    it 'should test that the factory is valid' do
      expect(build :ride).to be_valid
    end

    it 'should validate the presence of origin_lat' do
      ride = build :ride, origin_lat: nil
      expect(ride).not_to be_valid
      expect(ride.errors.messages[:origin_lat]).to include("can't be blank")
    end

    it 'should validate the presence of origin_lng' do
      ride = build :ride, origin_lng: nil
      expect(ride).not_to be_valid
      expect(ride.errors.messages[:origin_lng]).to include("can't be blank")
    end

    it 'should validate the presence of destination_lat' do
      ride = build :ride, destination_lat: nil
      expect(ride).not_to be_valid
      expect(ride.errors.messages[:destination_lat]).to include("can't be blank")
    end

    it 'should validate the presence of destination_lng' do
      ride = build :ride, destination_lng: nil
      expect(ride).not_to be_valid
      expect(ride.errors.messages[:destination_lng]).to include("can't be blank")
    end

    it 'should validate the presence of driver' do
      ride = build :ride, driver: nil
      expect(ride).not_to be_valid
      expect(ride.errors.messages[:driver]).to include("must exist")
    end
  end
end
