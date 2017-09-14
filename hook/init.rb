u = Userdata.new
u.redis_host = ENV['REDIS_HOST']
u.redis_port = ENV['REDIS_PORT'].to_i
u.endpoint = 'https://acme-v01.api.letsencrypt.org/'
u.endpoint = 'https://acme-staging.api.letsencrypt.org/' if ENV['STAGE'] =~ /^dev/
u.ttl = ENV['TTL'].to_i
