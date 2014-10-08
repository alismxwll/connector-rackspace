require 'spec_helper'

describe 'Compute' do
  describe 'Images' do
    it 'can list images' do

      username = ENV['RACKSPACE_USERNAME']
      api_key  = ENV['RACKSPACE_API_KEY']

      service_instance = service_instance('rackspace_compute_images')

      params = {
        'username' => username,
        'api_key' => api_key,
        'region' => 'dfw'
      }

      service_instance.test_action('list',params) do
        expect_info message:"Retrieving list of images"
        expect_return
      end
    end
  end
end