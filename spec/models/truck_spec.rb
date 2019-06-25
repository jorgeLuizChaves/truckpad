require 'rails_helper'

RSpec.describe Truck, type: :model do
  describe '#validations' do
    it 'should test that the factory is valid' do
      expect(build :truck).to be_valid
    end

    it 'should validate the presence of type' do
      truck = build :truck, type: nil
      expect(truck).not_to be_valid
      expect(truck.errors.messages[:type]).to include("can't be blank")
    end

    it 'should validate the presence of driver' do
      truck = build :truck, driver: nil
      expect(truck).not_to be_valid
      expect(truck.errors.messages[:driver]).to include("must exist")
    end

    it 'should validate the presence of driver_owner' do
      truck = build :truck, driver_owner: nil
      expect(truck).not_to be_valid
    end
  end
end