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
        schema type: :object,
               properties: {
                   data: {type: :array, items: { type: :object }}
               }
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
        schema type: :object,
           properties: {
             data: {type: :object,
                properties: {
                    id: {type: :string},
                    type: {type: :string},
                    attributes: {type: :object,
                       properties: {
                           name: {type: :string},
                           age: {type: :integer},
                           gender: {type: :string}
                       }
                    },
                    relationships: {type: :object,
                      properties: {
                        driver_license: {type: :object,
                           properties: {links: {type: :object,
                              properties: {
                                  related: {type: :string}
                              }
                           },
                              data: {type: :array, items: { type: :string }
                              }
                           }
                        },
                        truck: {type: :object}
                      }
                    }
                }
             }
           }

        let(:driver) {create :driver}
        let(:id) {driver.id}
        run_test!
      end
    end

    patch 'update driver' do
      tags 'Drivers'
      consumes 'application/json'
      parameter name: :id, :in => :path, :type => :string, description: 'driver id'


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
          # run_test!
      end

      response '200', 'entity update success' do
        schema type: :object, properties: {}
        #run_test!
      end
    end
  end
end