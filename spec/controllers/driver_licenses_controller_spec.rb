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
end
