require 'spec_helper'

describe 'Compute' do
  before do
    @service_instance = service_instance('rackspace_compute')
  end

  it 'can list servers' do
    @service_instance.test_action('list',@params) do
      expect_info message:"Retrieving list of servers"
      expect_return
    end
  end

  it 'can get a server' do
    
    compute_settings = {
      provider:'Rackspace',
      rackspace_username: @username,
      rackspace_api_key: @api_key,
      version: :v2,
      rackspace_region: 'dfw'
    }

    compute = Fog::Compute.new compute_settings
    servers = compute.servers.map {|s| s.attributes}
    server = servers.first

    get_params = @params.dup
    get_params['id'] = server[:id]

    @service_instance.test_action('get',get_params) do
      server_info = expect_return
      expect(server_info).to be
      expect(server_info).to be_a(Hash)
      expect(server_info.keys).to include(:payload)
      expect(server_info[:payload]).to be_a(Hash)
      expect(server_info[:payload]).to include(:id)
      expect(server_info[:payload][:id]).to eql(server[:id])
    end
  end

  it 'can SSH a server' do
    
    compute_settings = {
      provider:'Rackspace',
      rackspace_username: @username,
      rackspace_api_key: @api_key,
      version: :v2,
      rackspace_region: 'dfw'
    }

    compute = Fog::Compute.new compute_settings
    servers = compute.servers.map {|s| s.attributes}
    server = servers.first

    ssh_params = @params.dup
    ssh_params['id'] = server[:id]
    ssh_params['commands'] = ['pwd','ls -al']

    @service_instance.test_action('ssh',ssh_params) do
      server_info = expect_return
      expect(server_info).to be
      expect(server_info).to be_a(Hash)
      expect(server_info.keys).to include(:payload)
      expect(server_info[:payload]).to be_a(Array)
      expect(server_info[:payload].length).to be == 2
      expect(server_info[:payload][0]).to be_a(Hash)
      expect(server_info[:payload][1]).to be_a(Hash)
      expect(server_info[:payload][0]).to include(:stdout)
      expect(server_info[:payload][1]).to include(:stdout)
      expect(server_info[:payload][0][:stdout]).to be_a(String)
      expect(server_info[:payload][1][:stdout]).to be_a(String)
      expect(server_info[:payload][0][:stdout]).to include('/')
      expect(server_info[:payload][0][:stdout].length).to be > 0
    end
  end
end