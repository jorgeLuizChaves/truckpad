require 'swagger_helper'

describe 'Rides API' do
  shared_examples_for 'update_license' do
    tags 'Rides'
    consumes 'application/json'
    parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
    parameter name: :id, :in => :path, :type => :string, description: 'ride id'
    parameter name: :data, :in => :body, :type => :object, description: 'request body'

    response '422', 'update invalid' do
      let(:driver){create :driver}
      let(:ride) {create :ride, driver: driver}
      let(:id){ride.id}
      let(:driver_id){driver.id}
      let(:data) do
        {
            data: {
                attributes: {
                    origin: 'Google Office SP',
                    origin_lat: nil,
                    origin_lng: -46.6852194,
                    destination: 'Google Office NY',
                    destination_lat: 40.742131,
                    destination_lng: -74.0071718,
                    comeback_load: true
                }
            }
        }
      end
      run_test!
    end

    response '200', 'entity update success' do
      let(:driver){create :driver}
      let(:ride) {create :ride, driver: driver}
      let(:id){ride.id}
      let(:driver_id){driver.id}
      let(:data) do
        {
            data: {
                attributes: {
                    origin: 'Google Office SP',
                    origin_lat: -23.5477866,
                    origin_lng: -46.6852194,
                    destination: 'Google Office NY',
                    destination_lat: 40.742131,
                    destination_lng: -74.0071718,
                    comeback_load: true
                }
            }
        }
      end
      # schema type: :object, properties: {}
      run_test!
    end

    response '404', 'driver invalid' do
      let(:ride) {create :ride}
      let(:id){ride.id}
      let(:driver_id){99}
      let(:data) do
        {
            data: {
                attributes: {
                    origin: 'Google Office SP',
                    origin_lat: -23.5477866,
                    origin_lng: -46.6852194,
                    destination: 'Google Office NY',
                    destination_lat: 40.742131,
                    destination_lng: -74.0071718,
                    comeback_load: true
                }
            }
        }
      end
      # schema type: :object, properties: {}
      run_test!
    end

    response '404', 'ride invalid' do
      let(:driver){create :driver}
      let(:ride) {create :ride, driver: driver}
      let(:id){99}
      let(:driver_id){driver.id}
      let(:data) do
        {
            data: {
                attributes: {
                    origin: 'Google Office SP',
                    origin_lat: -23.5477866,
                    origin_lng: -46.6852194,
                    destination: 'Google Office NY',
                    destination_lat: 40.742131,
                    destination_lng: -74.0071718,
                    comeback_load: true
                }
            }
        }
      end
      # schema type: :object, properties: {}
      run_test!
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
        let(:driver) {create :driver}
        let(:driver_id) { driver.id }
        let(:page){1}
        let(:per_page){5}
        let(:rides) {create_list :ride, 3, driver: driver}
        run_test!
      end
    end

    post 'create driver license' do
      tags 'Rides'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :data, :in => :body, :type => :object, description: 'request body'

      response '201', 'ride created' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:data) do
          {
              data: {
                  attributes: {
                      origin: 'Google Office SP',
                      origin_lat: -23.5477866,
                      origin_lng: -46.6852194,
                      destination: 'Google Office NY',
                      destination_lat: 40.742131,
                      destination_lng: -74.0071718,
                      comeback_load: true
                  }
              }
          }
        end
        # schema type: :object, properties: {}
          run_test!
      end

      response '422', 'entity create error' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:data) do
          {
              data: {
                  attributes: {
                      origin: nil,
                      origin_lat: nil,
                      origin_lng: -46.6852194,
                      destination: 'Google Office NY',
                      destination_lat: 40.742131,
                      destination_lng: -74.0071718,
                      comeback_load: true
                  }
              }
          }
        end
        schema type: :object, properties: {}
        run_test!
      end

      response '404', 'driver not found' do
        let(:driver_id){99}
        let(:data) do
          {
              data: {
                  attributes: {
                      origin: nil,
                      origin_lat: nil,
                      origin_lng: -46.6852194,
                      destination: 'Google Office NY',
                      destination_lat: 40.742131,
                      destination_lng: -74.0071718,
                      comeback_load: true
                  }
              }
          }
        end
        # schema type: :object, properties: {}
        run_test!
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

    patch 'update ride' do
      it_behaves_like 'update_license'
    end

    put 'update ride' do
      it_behaves_like 'update_license'
    end

    delete 'delete ride' do
      tags 'Rides'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'ride id'

      response '200', 'deleted successful' do
        let(:driver){create :driver}
        let(:ride){create :ride, driver: driver}
        let(:driver_id){driver.id}
        let(:id){ride.id}
        run_test!
      end

      response '404', 'driver not found' do
        let(:driver_id){99}
        let(:id){99}
        run_test!
      end

      response '404', 'ride not found' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:id){99}
        run_test!
      end
    end
  end
end