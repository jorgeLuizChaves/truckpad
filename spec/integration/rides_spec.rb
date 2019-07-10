require 'swagger_helper'

describe 'Rides API' do
  shared_examples_for 'update_license' do
    tags 'Rides'
    consumes 'application/json'
    parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
    parameter name: :id, :in => :path, :type => :string, description: 'ride id'

    response '422', 'invalid entity to update' do
      schema type: :object, properties: {}
      # run_test!
    end

    response '200', 'entity update success' do
      schema type: :object, properties: {}
      # run_test!
    end
  end

  path '/drivers/{driver_id}/rides' do
    get 'get licenses by driver' do
      tags 'Rides'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id', schema: {
          type: :integer,
      }
      parameter name: :page, :in => :query, :type => :Integer, description: 'current page of a result (default 1)'
      parameter name: :per_page, :in => :query, :type => :Integer, description: 'number of entities per page (default 3)'

      response '200', 'list all rides' do
        let(:driver_id) { driver.id }
        # run_test!
      end
    end

    post 'create driver license' do
      tags 'Rides'
      consumes 'application/json'

      response '201', 'created' do
        schema type: :object, properties: {}
          # run_test!
      end

      response '422', 'entity update success' do
        schema type: :object, properties: {}
          # run_test!
      end
    end
  end

  path '/drivers/{driver_id}/rides/{id}' do
    get 'get ride by id' do
      tags 'Rides'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'driver id'

      response '404', 'driver not found' do
        schema type: :object, properties: {}
        # run_test!
      end
      response '200', 'driver found' do
        schema type: :object,
        properties: {
          data: {type: :object,
            properties: {
              id: {type: :integer},
              type: {type: :string},
              attributes: {type: :object,
                           properties: {
                               "name": {type: :string},
                               "age": {type: :integer},
                               "gender": {type: :string},
                           }
              },
              relationships: {type: :object,
                properties: {
                  "driver_license": {type: :object,
                    properties: {links: {type: :object,
                      properties: {
                        "related": {type: :string}
                      }
                    },
                      data: {
                          type: :array, items: { type: 'string' }
                      }
                    }
                  },
                  "truck": {type: :object}
                }
              }
            }
          }
        }
          # run_test!
      end

    end

    patch 'update license' do
      it_behaves_like 'update_license'
    end

    put 'update license' do
      it_behaves_like 'update_license'
    end
  end
end