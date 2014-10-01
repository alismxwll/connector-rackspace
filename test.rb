require 'awesome_print'
Dir.glob('./lib/factor/connector/*.rb').each { |f| require f }

rackspace_username = 'skierkowski'
rackspace_api_key  = 'd3aea086db5e981c2ead3a7098bfe852'
# rackspace_api_key  = 'ead3a7098bfe852'

service_manager = Factor::Connector.get_service_manager('rackspace_compute_flavors')

service_instance = service_manager.instance

service_instance.callback = proc do |action_response|
  if action_response[:type]=='return'
    ap action_response[:payload]
  else
    puts action_response
  end
end


params={
  'username' => rackspace_username,
  'api_key' => rackspace_api_key,
  'region' => 'dfw'
}



service_instance.call_action('list',params)

# params['id'] = '1d8173b8-6efc-4f40-a134-d5cff5c1fe4a'
# service_instance.call_action('server_get',params)






sleep 10