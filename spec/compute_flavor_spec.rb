require 'spec_helper'

describe 'Compute' do
  describe 'Flavors' do
    it 'can list servers' do
      service_instance = service_instance('rackspace_compute_flavors')

      service_instance.test_action('list',@params) do
        expect_info message:"Retrieving list of flavors"
        expect_return
      end
    end
  end
end