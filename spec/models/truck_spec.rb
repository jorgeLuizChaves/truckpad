require 'rails_helper'

RSpec.describe Truck, type: :model do
  describe '#validations' do
    it 'should test that the factory is valid' do
      expect(build :truck).to be_valid
    end

    it 'should validate the presence of category' do
      truck = build :truck, category: nil
      expect(truck).not_to be_valid
      expect(truck.errors.messages[:category]).to include("can't be blank")
    end

    it 'should validate the category' do
      truck = build :truck, category: :ABC
      expect(truck).not_to be_valid
      expect(truck.errors.messages[:category]).to include("This truck category isn't valid")
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