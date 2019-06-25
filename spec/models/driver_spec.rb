require 'rails_helper'

RSpec.describe Driver, type: :model do
  describe '#validations' do
    it 'should test that the factory is valid' do
      expect(build :driver).to be_valid
    end

    it 'should validate the presence of name' do
      driver = build :driver, name: ''
      expect(driver).not_to be_valid
      expect(driver.errors.messages[:name]).to include("can't be blank")
    end

    it 'should validate the presence of age' do
      driver = build :driver, age: nil
      expect(driver).not_to be_valid
      expect(driver.errors.messages[:age]).to include("can't be blank")
    end

    it 'should allow only integers on drive\'s age' do
      driver = build :driver, age: "abcd"
      expect(driver).not_to be_valid
      expect(driver.errors.messages[:age]).to include("is not a number")
    end

    it 'should validate driver\'s age' do
      driver = build :driver, age: 15
      expect(driver).not_to be_valid
      expect(driver.errors.messages[:age]).to include("It's too young, You can't driver a truck legally.")
    end

    it 'should validate the presence of gender' do
      driver = build :driver, gender: nil
      expect(driver).not_to be_valid
    end

    it 'should validate gender values options' do
      driver = build :driver, gender: :UNKNOWN
      expect(driver).not_to be_valid
    end
  end
end