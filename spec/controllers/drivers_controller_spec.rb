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
              'category': :C,
              'expiration_date': '2020-01-01'
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

      it 'should create an driver license' do
        expect{subject}.to change{DriverLicense.count}.by 1
      end
    end

    context 'when some parameter is invalid' do
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
      subject { post :create, params: invalid_entity_name}

      it 'should return http status code unprocessabe_entity' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'should return proper json to name' do
        subject
        expect(json_errors).to include({
             "source" => { "pointer" => "/data/attributes/name" },
             "detail" => "can't be blank"
         })
      end

      it 'should return proper json to gender' do
        subject
        expect(json_errors).to include({
          "source" => { "pointer" => "/data/attributes/gender" },
          "detail" => "can't be blank"
        })
      end

      it 'should return proper json to age' do
        subject
        expect(json_errors).to include({
          "source" => { "pointer" => "/data/attributes/age" },
          "detail" => "can't be blank"
        })
      end
    end
  end
end
