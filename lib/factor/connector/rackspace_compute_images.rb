require 'factor-connector-api'
require 'fog'

Factor::Connector.service 'rackspace_compute_images' do

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

    info "Retreiving list of images"
    begin
      images = compute.images.map {|s| s.attributes}
    rescue
      fail "Failed to retrieve list of images"
    end

    action_callback images
  end

  action 'get' do |params|
    username  = params['username']
    api_key   = params['api_key']
    image_id = params['id']
    region    = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Image ID is required" unless image_id

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

    info "Retreiving image"
    begin
      image = compute.images.get(server_id).attributes
    rescue
      fail "Failed to retrieve image"
    end

    action_callback image
  end

end