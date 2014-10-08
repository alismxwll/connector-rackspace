require 'spec_helper'

describe 'Compute' do
  describe 'Flavors' do
    it 'can list servers' do

      username = ENV['RACKSPACE_USERNAME']
      api_key  = ENV['RACKSPACE_API_KEY']

      service_instance = service_instance('rackspace_compute_flavors')

      params = {
        'username' => username,
        'api_key' => api_key,
        'region' => 'dfw'
      }

      service_instance.test_action('list',params) do
        expect_info message:"Retrieving list of flavors"
        expect_return
      end
    end
  end
end