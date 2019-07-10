require 'rails_helper'

RSpec.describe DriverLicensesController, type: :controller do
  describe '#index' do
    subject {get :index, params: {driver_id: 1}}
    context 'when license is not found' do
      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#create' do
    let(:driver) do
      create :driver
    end
    let(:json_create_ok) do
      {
          driver_id: driver.id,
          data: {
              type: 'driver_license',
              attributes:  {
                  category: 'SIMPLE',
                  expiration_date: '2020-01-01'
              }
          }
      }
    end

    let(:json_create_invalid_user) do
      {
          driver_id: 88,
          data: {
              type: 'driver_license',
              attributes:  {
                  category: nil,
                  expiration_date: '2020-01-01'
              }
          }
      }
    end

    let(:json_create_nok) do
      {
          driver_id: driver.id,
          data: {
              type: 'driver_license',
              attributes:  {
                  category: nil,
                  expiration_date: '2020-01-01'
              }
          }
      }
    end

    context 'when success' do
      subject {post :create, params: json_create_ok}
      it 'should return status code 201' do
        subject
        expect(response).to have_http_status :created
      end
    end

    context 'when require attributes not filled' do
      subject {post :create, params: json_create_nok}
      it 'should return status code 422' do
        subject
        expect(response).to have_http_status :unprocessable_entity
      end
    end

    context 'when drive doesn\'t exist' do
      subject {post :create, params: json_create_invalid_user}
      it 'should return status code 422' do
        subject
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe '#update' do
    let(:driver) do
      create :driver
    end

    let(:license) do
      create :driver_license, driver: driver
    end

    context 'when success' do

      let(:json_ok) do
        {
            driver_id: driver.id,
            id: license.id,
            data:
                {
                    attributes: {
                        category: :A,
                        expiration_date: '2021-01-01'
                    }
                }
        }
      end

      subject {put :update, params: json_ok}
      it 'should return status code 200' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should validate proper json' do
        subject
        expect(json_data['attributes']).to include({
            'category' => 'A',
            'expiration_date' =>  '2021-01-01'
         })
      end
    end

    context 'when driver is invalid' do
      let(:json_ok) do
        {
            driver_id: 99,
            id: license.id,
            data:
                {
                    attributes: {
                        category: :A,
                        expiration_date: '2021-01-01'
                    }
                }
        }
      end

      subject {put :update, params: json_ok}
      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when license is invalid' do
      let(:json_ok) do
        {
            driver_id: driver.id,
            id: 99,
            data:
                {
                    attributes: {
                        category: :A,
                        expiration_date: '2021-01-01'
                    }
                }
        }
      end
      subject {put :update, params: json_ok}
      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#destroy' do
    context 'when destroy successful'   do
      let(:driver) do
        create :driver
      end

      let(:license) do
        create :driver_license, driver: driver
      end

      let(:destroy_ok) do
        {
            id: driver.id,
            driver_id: license.id
        }
      end

      subject {delete :destroy, params: destroy_ok}

      it 'should return status code ok' do
        subject
        expect(response).to have_http_status :ok
      end

      it 'should update driver_license to :INACTIVE' do
        subject
        expect { license.reload }.to change(license, :status)
      end
    end

    context 'when driver is invalid' do
      let(:driver) do
        create :driver
      end

      let(:license) do
        create :driver_license, driver: driver
      end

      let(:destroy_params_invalid_driver) do
        {
            id: driver.id,
            driver_id: 99
        }
      end

      subject {delete :destroy, params: destroy_params_invalid_driver}

      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end

    context 'when license is invalid' do
      let(:driver) do
        create :driver
      end

      let(:license) do
        create :driver_license, driver: driver
      end

      let(:destroy_params_invalid_license) do
        {
            id: 99,
            driver_id: driver.id
        }
      end

      subject {delete :destroy, params: destroy_params_invalid_license}

      it 'should return status code not found' do
        subject
        expect(response).to have_http_status :not_found
      end
    end
  end
end
