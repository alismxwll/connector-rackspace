require 'spec_helper'

describe 'Compute' do
  it 'can list stuff' do

    username = ENV['RACKSPACE_USERNAME']
    api_key  = ENV['RACKSPACE_API_KEY']

    service_instance = service_instance('rackspace_compute')

    received_payload = false
    service_instance.callback = proc do |action_response|
      if action_response[:payload]
        received_payload = true
      end
    end

    params={
      'username' => username,
      'api_key' => api_key,
      'region' => 'dfw'
    }

    service_instance.call_action('list',params)

    eventually timeout: 10 do
      received_payload
    end
  end
end