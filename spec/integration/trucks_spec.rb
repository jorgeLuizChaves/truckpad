require 'swagger_helper'

describe 'Truck API' do

  path '/trucks' do
    get 'get trucks' do

    end
  end

  path '/drivers/{driver_id}/trucks' do

    get 'get licenses by driver' do
      tags 'Trucks'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :page, :in => :query, :type => :Integer, description: 'current page of a result (default 1)'
      parameter name: :per_page, :in => :query, :type => :Integer, description: 'number of entities per page (default 3)'

      response '200', 'when driver has trucks' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:truck){create :truck, driver: driver}
        let(:page){nil}
        let(:per_page){nil}

        schema type: :object, properties: {
            data: { type: :array,
                    items: { '$ref' => '#/definitions/truck' }
            }
        }
        run_test!
      end
    end

    post 'create trucks' do
      tags 'Trucks'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :data, in: :body,schema: { }

      response '201', 'created' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:data)do
          {
              data:{
                  attributes:{
                      category: 'TOCO',
                      model: 'model',
                      brand: 'brand',
                      is_loaded: true,
                      driver_owner: true
                  }
              }
          }
        end
        schema '$ref' => '#/definitions/truck'
        run_test!
      end

      response '404', 'driver not found' do
        let(:driver_id){99}
        let(:data){nil}
        run_test!
      end

      response '422', 'entity update success' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:data)do
          {
              data:{
                  attributes:{
                      category: nil,
                      model: 'model',
                      brand: 'brand',
                      is_loaded: true,
                      driver_owner: true
                  }
              }
          }
        end
        run_test!
      end
    end
  end

  path '/drivers/{driver_id}/trucks/{id}' do

    shared_examples_for 'update_truck' do
      tags 'Trucks'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'truck id'
      parameter name: :data, in: :body,schema: { }

      response '422', 'invalid entity to update' do
        # schema type: :object, properties: {}
        #run_test!
      end

      response '404', 'driver not found' do
        let(:driver_id){99}
        let(:id){99}
        let(:data){nil}
        # schema type: :object, properties: {}
        # run_test!
      end

      response '404', 'driver not found' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:id){99}
        let(:data) do
          {}
        end
        # schema type: :object, properties: {}
        # run_test!
      end

      response '200', 'entity update success' do
        let(:driver) {create :driver}
        let(:truck) {create :truck, driver: driver}
        let(:driver_id) {driver.id}
        let(:id) {truck.id}

        let(:data)do
          {
              data:{
                  attributes:{
                      category: 'TOCO',
                      model: 'updated',
                      brand: 'updated',
                      is_loaded: false,
                      driver_owner: false
                  }
              }
          }
        end
        run_test!
      end
    end

    patch 'update license' do
      it_behaves_like 'update_truck'
    end

    put 'update license' do
      it_behaves_like 'update_truck'
    end

    delete 'delete truck' do
      tags 'Trucks'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'license id'

      response '404', 'driver not found' do
        let(:driver_id){99}
        let(:id){99}
        run_test!
      end

      response '404', 'truck not found' do
        let(:driver){create :driver}
        let(:truck){create :truck, driver: driver}
        let(:driver_id){driver.id}
        let(:id){99}
        run_test!
      end

      response '200', 'truck delete' do
        let(:driver) {create :driver}
        let(:truck){create :truck, driver: driver}
        let(:driver_id){driver.id}
        let(:id){truck.id}
        run_test!
      end
    end
  end
end