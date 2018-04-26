def return_backend_server(redis, domain)
  return '127.0.0.1:10080' if not_allowed_domain?(redis, domain)
  servers = redis.lrange domain, 0, -1
  servers[rand(servers.length)]
rescue
  '127.0.0.1:10080'
end

def not_allowed_domain?(redis, domain)
  true unless redis.exists?(domain)
end

u = Userdata.new
redis = Redis.new u.redis_host, u.redis_port
domain = Nginx::Request.new.hostname
Nginx.echo domain
return_backend_server(redis, domain)
