domain = Nginx::Request.new.hostname
redis = Redis.new 'redis', 6379
servers = redis.lrange domain, 0, -1
return servers[rand(servers.length)]
