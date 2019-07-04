require 'swagger_helper'

describe 'Drivers API' do
  get 'Get Drivers' do
    path '/drivers' do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :pet, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          photo_url: { type: :string },
          status: { type: :string }
        },
        required: [ 'name', 'status' ]
      }
      
      response '201', 'pet created' do
        let(:pet) { { name: 'Dodo', status: 'available' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:pet) { { name: 'foo' } }
        run_test!
      end
    end
  end
end