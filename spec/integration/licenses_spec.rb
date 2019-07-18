require 'swagger_helper'

describe 'Licenses API' do
  path '/drivers/{driver_id}/licenses' do

    get 'get licenses by driver' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :page, :in => :query, :type => :Integer, description: 'current page of a result (default 1)'
      parameter name: :per_page, :in => :query, :type => :Integer, description: 'number of entities per page (default 3)'

      response '200', 'show driver license' do
        let(:driver) do
          create :driver
        end

        let(:driver_license) do
          create :driver_license, driver: driver
        end

        let(:driver_id){driver_license.driver.id}
        let(:page) {nil}
        let(:per_page){nil}

        # schema type: :object,
        #        properties: {
        #            data: {type: :array, items: { type: :object }}
        #        }
        run_test!
      end

      response '404', 'when driver is invalid' do
        let(:driver_id){99}
        let(:page) {nil}
        let(:per_page){nil}
        run_test!
      end

      response '200', 'when drivers has no license' do
        let(:driver_without_license) do
          create :driver
        end

        let(:driver_id){driver_without_license.id}
        let(:page) {nil}
        let(:per_page){nil}
        run_test!
      end
    end

    post 'create driver\'s license' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :data, in: :body,schema: {
          type: :object,
          properties: {
              data: {
                  type: :object,
                  properties: {
                      attributes: {type: :object,
                       properties: {
                           category: {type: :string},
                           expiration_date: {type: :string}
                       }}
                  }
              }
          }
      }

      response '201', 'driver\'s license created' do
        let(:driver){create :driver}
        let(:driver_id) {driver.id}
        let(:data) do
          {
              data: {
                  attributes: {
                      category: 'C',
                      expiration_date: '2030-02-02'
                  }
              }
          }
        end
        schema '$ref' => '#/definitions/license'
        run_test!
      end

      response '422', 'error to create driver\'s license' do
        let(:driver){create :driver}
        let(:driver_id) {driver.id}
        let(:data) do
          {
              data: {
                  attributes: {
                      category: nil,
                      expiration_date: nil
                  }
              }
          }
        end
        run_test!
      end
    end
  end

  path '/drivers/{driver_id}/licenses/{id}' do

    shared_examples_for 'update_license' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'license id'
      parameter name: :data, in: :body,schema: {
          type: :object,
          properties: {
              data: {
                  type: :object,
                  properties: {
                      attributes: {type: :object,
                         properties: {
                             category: {type: :string},
                             expiration_date: {type: :string}
                         }}
                  }
              }
          }
      }

      response '422', 'invalid entity to update' do
        let(:driver){create :driver}
        let(:license){create :driver_license, driver: driver}
        let(:driver_id){driver.id}
        let(:id){license.id}
        let(:data) do
          {
              data: {
                  attributes:{
                      category: nil,
                      expiration_date: nil
                  }
              }
          }
        end
        run_test!
      end

      response '200', 'entity update success' do
        let(:driver){create :driver}
        let(:license){create :driver_license, driver: driver}
        let(:driver_id){driver.id}
        let(:id){license.id}
        let(:data) do
          {
              data: {
                  attributes:{
                      category: 'A',
                      expiration_date: '2100-01-01'
                  }
              }
          }
        end
        schema '$ref' => '#/definitions/license'
        run_test!
      end
    end

    delete 'delete license by driver' do
      tags 'Licenses'
      consumes 'application/json'
      parameter name: :driver_id, :in => :path, :type => :string, description: 'driver id'
      parameter name: :id, :in => :path, :type => :string, description: 'license id'

      response '404', 'driver not found' do
        let(:driver_id){99}
        let(:id){99}
        run_test!
      end

      response '404', 'license not found' do
        let(:driver){create :driver}
        let(:driver_id){driver.id}
        let(:id){99}
        run_test!
      end

      response '200', 'license deleted' do
        let(:driver){create :driver}
        let(:license){create :driver_license, driver: driver}
        let(:driver_id){driver.id}
        let(:id){license.id}
        run_test!
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