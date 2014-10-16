require 'spec_helper'

describe 'Compute' do
  describe 'Images' do
    it 'can list images' do
      service_instance = service_instance('rackspace_compute_images')

      service_instance.test_action('list',@params) do
        expect_info message:"Retrieving list of images"
        expect_return
      end
    end
  end
end