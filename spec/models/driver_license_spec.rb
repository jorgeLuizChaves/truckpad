require 'rails_helper'

RSpec.describe DriverLicense, type: :model do
  describe "#validations" do
    it 'should test that the factory is valid' do
      expect(build :driver_license).to be_valid
    end

    it 'should validate the presence of type' do
      license = build :driver_license, type: nil
      expect(license).not_to be_valid
      expect(license.errors.messages[:type]).to include("can't be blank")
    end

    it 'should validate the presence of expiration_date' do
      license = build :driver_license, expiration_date: nil
      expect(license).not_to be_valid
      expect(license.errors.messages[:expiration_date]).to include("can't be blank")
    end

    it 'should validate the presence of driver' do
      license = build :driver_license, driver: nil
      expect(license).not_to be_valid
      expect(license.errors.messages[:driver]).to include("must exist")
    end
  end

end