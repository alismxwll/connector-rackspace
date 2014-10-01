require 'factor-connector-api'
require 'fog'

Factor::Connector.service 'rackspace_compute_flavors' do

  action 'list' do |params|
    username = params['username']
    api_key = params['api_key']
    region = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key

    compute_settings = {
      provider:'Rackspace',
      rackspace_username:username,
      rackspace_api_key:api_key,
      version: :v2,
      rackspace_region: region
    }

    info "Initializing connection settings"
    begin
      compute = Fog::Compute.new compute_settings
    rescue
      fail "Couldn't initialize connection"
    end

    info "Retreiving list of flavors"
    begin
      flavors = compute.flavors.map {|s| s.attributes}
    rescue
      fail "Failed to retrieve list of flavors"
    end

    action_callback flavors
  end

  action 'get' do |params|
    username  = params['username']
    api_key   = params['api_key']
    flavor_id = params['id']
    region    = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Flavor ID is required" unless flavor_id

    compute_settings = {
      provider:'Rackspace',
      rackspace_username:username,
      rackspace_api_key:api_key,
      version: :v2,
      rackspace_region: region
    }

    info "Initializing connection settings"
    begin
      compute = Fog::Compute.new compute_settings
    rescue
      fail "Couldn't initialize connection"
    end

    info "Retreiving flavor"
    begin
      flavor = compute.flavors.get(server_id).attributes
    rescue
      fail "Failed to retrieve flavor"
    end

    action_callback flavor
  end

end