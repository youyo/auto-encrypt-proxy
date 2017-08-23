def backend
  domain = Nginx::Request.new.hostname
  redis = Redis.new 'redis', 6379
  return '127.0.0.1:10080' unless redis.exists?(domain)
  servers = redis.lrange domain, 0, -1
  servers[rand(servers.length)]
end

backend
