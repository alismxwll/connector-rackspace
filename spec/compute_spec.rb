require 'spec_helper'

describe 'Compute' do
  it 'can list servers' do

    username = ENV['RACKSPACE_USERNAME']
    api_key  = ENV['RACKSPACE_API_KEY']

    service_instance = service_instance('rackspace_compute')

    params = {
      'username' => username,
      'api_key' => api_key,
      'region' => 'dfw'
    }

    service_instance.test_action('list',params) do
      expect_info message:"Retrieving list of servers"
      expect_return
    end
  end
end