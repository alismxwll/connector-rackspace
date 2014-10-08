require 'factor-connector-api'
require 'fog'

Factor::Connector.service 'rackspace_compute' do

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

    info "Retrieving list of servers"
    begin
      servers = compute.servers.map {|s| s.attributes}
    rescue
      fail "Failed to retrieve list of servers"
    end

    action_callback servers
  end

  action 'get' do |params|
    username  = params['username']
    api_key   = params['api_key']
    server_id = params['id']
    region    = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Server ID is required" unless server_id

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

    info "Retrieving servers"
    begin
      server = compute.servers.get(server_id).attributes
    rescue
      fail "Failed to retrieve server"
    end

    action_callback server
  end

  action 'create' do |params|
    username  = params['username']
    api_key   = params['api_key']
    flavor_id = params['flavor_id']
    image_id  = params['image_id']
    region    = (params['region'] || 'ord').to_sym
    name      = params['name']
    wait      = params['wait']

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Flavor ID is required" unless flavor_id
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

    server_settings = {
      flavor_id: flavor_id,
      image_id: image_id
    }
    server_settings[:name] = name if name

    info "Creating server"
    begin
      server = compute.servers.create(server_settings)
    rescue
      fail "Failed to create server with provided settings"
    end

    if wait
      info "Waiting for the server. This can take a few minutes."
      begin
        server.wait_for { ready? }
        server.reload
      rescue
        warn "Server creation started, but couldn't get the status"
      end
    else
      info "Server creation has been queued"
    end

    server_info = server.attributes

    action_callback server_info
  end

  action 'bootstrap' do |params|
    username  = params['username']
    api_key   = params['api_key']
    flavor_id = params['flavor_id']
    image_id  = params['image_id']
    private_key = params['private_key']
    public_key = params['public_key']
    region    = (params['region'] || 'ord').to_sym
    name      = params['name']

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Flavor ID is required" unless flavor_id
    fail "Image ID is required" unless image_id
    fail "Private Key is required" unless private_key
    fail "Public Key is required" unless public_key
    

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

    info 'Setting up private key'
    begin
      private_key_file = Tempfile.new('private')
      private_key_file.write(private_key)
      private_key_file.close
    rescue
      fail 'Failed to setup private key'
    end

    info 'Setting up public key'
    begin
      public_key_file = Tempfile.new('public')
      public_key_file.write(public_key)
      public_key_file.close
    rescue
      fail 'Failed to setup public key'
    end
    
    server_settings = {
      flavor_id: flavor_id,
      image_id: image_id,
      public_key_path: public_key_file.path,
      private_key_path: private_key_file.path
    }
    server_settings[:name] = name if name

    info "Creating server"
    begin
      server = compute.servers.bootstrap(server_settings)
    rescue
      fail "Failed to create server with provided settings"
    end

    info "Waiting for the server. This can take a few minutes."
    begin
      server.wait_for { ready? }
    rescue
      fail "Server creation started, but couldn't get the status"
    end

    server.reload
    server_info = server.attributes

    action_callback server_info
  end

  action 'ssh' do |params|
    username  = params['username']
    api_key   = params['api_key']
    server_id = params['id']
    region    = (params['region'] || 'ord').to_sym
    commands  = params['commands']

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Server ID is required" unless server_id
    fail "Commands is required" unless commands
    fail "Commands must be an array of strings" unless commands.is_a?(Array)
    fail "Commands must be an array of strings" unless commands.all?{|c| c.is_a?(String)}

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

    info "Retreiving server #{server_id}"
    begin
      server = compute.servers.get(server_id)
      server_info = server.attributes
    rescue
      fail "Failed to retrieve server #{server_id}"
    end

    info "Executing commands on server #{server_id}"
    begin
      ssh_results = server.ssh(commands)

      call_response = ssh_results.map do |ssh_result|
        {
          status:  ssh_result.status,
          command: ssh_result.command,
          stderr:  ssh_result.stderr,
          stdout:  ssh_result.stdout
        }
      end

    rescue
      fail "Failed to execute commands on server #{server_id}"
    end

    action_callback call_response
  end

  action 'delete' do |params|
    username  = params['username']
    api_key   = params['api_key']
    server_id = params['id']
    region    = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Server ID is required" unless server_id

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

    info "Retreiving servers"
    begin
      server = compute.servers.get(server_id)
      server_info = server.attributes
    rescue
      fail "Failed to retrieve server"
    end

    info "Deleting server"
    begin
      server.destroy
    rescue
      fail "Failed to destroy server"
    end

    action_callback server
  end

  action 'reboot' do |params|
    username  = params['username']
    api_key   = params['api_key']
    server_id = params['id']
    region    = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Server ID is required" unless server_id

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

    info "Retreiving server"
    begin
      server = compute.servers.get(server_id)
      server_info = server.attributes
    rescue
      fail "Failed to retrieve server"
    end

    info "Rebooting server"
    begin
      server.reboot
    rescue
      fail "Failed to reboot server"
    end

    action_callback server
  end

  action 'change_password' do |params|
    username  = params['username']
    api_key   = params['api_key']
    server_id = params['id']
    new_password = params['new_password']
    region    = (params['region'] || 'ord').to_sym

    fail "Username is required" unless username
    fail "API Key is required" unless api_key
    fail "Server ID is required" unless server_id
    fail "New Password is required" unless new_password

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

    info "Retreiving server"
    begin
      server = compute.servers.get(server_id)
      server_info = server.attributes
    rescue
      fail "Failed to retrieve server"
    end

    info "Rebooting server"
    begin
      server.change_admin_password(new_password)
    rescue
      fail "Failed to reboot server"
    end

    action_callback server
  end

end