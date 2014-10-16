require 'spec_helper'

describe 'Compute' do
  it 'can list servers' do
    service_instance = service_instance('rackspace_compute')

    service_instance.test_action('list',@params) do
      expect_info message:"Retrieving list of servers"
      expect_return
    end
  end

  it 'can get a server' do
    service_instance = service_instance('rackspace_compute')

    service_instance.test_action('list',@params) do
      expect_info message:"Retrieving list of servers"
      expect_return
    end
  end
end