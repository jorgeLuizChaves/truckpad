require 'swagger_helper'

describe 'Driver Licenses API' do
  path '/drivers/{driver_id}/licenses' do

    get 'get licenses by driver' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :page, :in => :query, :type => :Integer, description: 'current page of a result (default 1)'
      parameter name: :per_page, :in => :query, :type => :Integer, description: 'number of entities per page (default 3)'

      response '200', 'show driver license' do
        schema type: :object,
               properties: {
                   data: {type: :array, items: { type: :object }}
               }
        #run_test!
      end
    end

    post 'create driver\'s license' do
      tags 'Licenses'
      consumes 'application/json'

      response '201', 'driver\'s license created' do
        schema type: :object, properties: {}
          #run_test!
      end

      response '422', 'error to create driver\'s license' do
        schema type: :object, properties: {}
          #run_test!
      end
    end
  end

  path '/drivers/{driver_id}/licenses/{id}' do

    delete 'delete license by driver' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'license id'

      response '404', 'driver not found' do
        schema type: :object, properties: {}
        #run_test!
      end

      response '200', 'driver not found' do
        schema type: :object, properties: {}
          #run_test!
      end
    end

    get 'get license by id' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :string, description: 'driver id'

      response '404', 'driver not found' do
        schema type: :object, properties: {}
          #run_test!
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
                                                                                  data: {type: :array, items: { type: 'string' }
                                                                                  }
                                                                     }
                                                  },
                                                  "truck": {type: :object}
                                              }
                              }
                          }
                   }
               }
        let(:id) { Driver.create(title: 'foo', content: 'bar').id }
          #run_test!
      end

    end

    patch 'update license' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'license id'

      response '422', 'invalid entity to update' do
        schema type: :object, properties: {}
          #run_test!
      end

      response '200', 'entity update success' do
        schema type: :object, properties: {}
          #run_test!
      end
    end

    put 'update license' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'license id'

      response '422', 'invalid entity to update' do
        schema type: :object, properties: {}
          #run_test!
      end

      response '200', 'entity update success' do
        schema type: :object, properties: {}
          #run_test!
      end
    end
  end
end