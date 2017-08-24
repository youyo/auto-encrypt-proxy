def return_backend_server(redis, domain)
  return '127.0.0.1:10080' unless redis.exists?(domain)
  servers = redis.lrange domain, 0, -1
  servers[rand(servers.length)]
rescue
  '127.0.0.1:10080'
end

redis = Redis.new 'redis', 6379
domain = Nginx::Request.new.hostname
return_backend_server(redis, domain)
