require 'swagger_helper'

describe 'Drivers API' do
  path '/drivers' do
    get 'list all drivers' do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :owner, :in => :query, :type => :string, description: 'Whether drivers have their own truck'
      parameter name: :page, :in => :query, :type => :Integer, description: 'current page of a result (default 1)'
      parameter name: :per_page, :in => :query, :type => :Integer, description: 'number of entities per page (default 3)'

      response '200', 'list all drivers' do
        schema type: :object, properties: {
            data: { type: :array,
                items: { '$ref' => '#/definitions/driver' }
            }
        }
        let(:drivers) { create_list :driver, 2}
        let(:page) {1}
        let(:per_page) {1}
        let(:owner) {true}
        run_test!
      end
    end

    post 'create driver' do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :data, in: :body,schema: {
          type: :object,
          properties: {
            data: {
              type: :object,
                properties: {
                  attributes: {type: :object,
                    properties: {
                      name: {type: :string},
                      age: {type: :string},
                      gender: {type: :string}
                  }}
                }
              }
          }
      }

      response '201', 'created' do
        schema '$ref' => '#/definitions/driver'
        let(:data) do
        {
          data: {
            attributes:
              {
                name: 'test',
                age: 30,
                gender: :MALE
              }
          }
        }
        end
        run_test!
      end

      response '422', 'entity update success' do
        let(:data) do
        {
          data: {
            attributes:
              {
                name: nil,
                age: nil,
                gender: nil
              }
          }
        }
        end
        run_test!
      end
    end
  end

  shared_examples_for 'update_driver' do
    tags 'Drivers'
    consumes 'application/json'
    parameter name: :id, :in => :path, :type => :string, description: 'driver id'
    parameter name: :data, in: :body,schema: {
        type: :object,
        properties: {
            data: {
                type: :object,
                properties: {
                    attributes: {type: :object,
                       properties: {
                         name: {type: :string},
                         age: {type: :string},
                         gender: {type: :string}
                    }}
                }
            }
        }
    }


    response '422', 'invalid entity to update' do
      let(:driver) {create :driver}
      let(:id) {driver.id}
      let(:data) do
        {
          data: {
            attributes:
              {
                name: nil,
                age: nil,
                gender: nil
              }
          }
        }
      end
      run_test!
    end

    response '200', 'entity update success' do
      let(:driver) {create :driver}
      let(:id) {driver.id}
      let(:data) do
        {
          data: {
            attributes:
              {
                name: 'new-name',
                age: 99,
                gender: :FEMALE
              }
          }
        }
      end
      schema '$ref' => '#/definitions/driver'
      run_test!
    end
  end

  path '/drivers/{id}' do
    get 'get driver by id' do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :string, description: 'driver id'

      response '404', 'driver not found' do
        let(:id) {99}
        let(:data) do
          {
            data: {
              attributes:
                {
                  name: nil,
                  age: nil,
                  gender: nil
                }
            }
          }
        end
        run_test!
      end

      response '200', 'driver found' do
        schema '$ref' => '#/definitions/driver'

        let(:driver) {create :driver}
        let(:id) {driver.id}
        schema '$ref' => '#/definitions/driver'
        run_test!
      end
    end

    put 'update driver' do
      it_behaves_like 'update_driver'
    end

    patch 'update driver' do
      it_behaves_like 'update_driver'
    end

    delete 'delete driver' do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :string, description: 'driver id'

      response '200', 'entity deleted successfully' do
        let(:driver) {create :driver}
        let(:id) {driver.id}
        run_test!
      end

      response '404', 'entity not found' do
        let(:id) {99}
        run_test!
      end
    end
  end
end