def token_value(redis, domain)
  token_value = redis["#{domain}_token_value"]
  token_value
rescue
  'can_not_get_token_value'
end

u = Userdata.new
redis = Redis.new u.redis_host, u.redis_port
domain = Nginx::Request.new.hostname
Nginx.rputs token_value(redis, domain)
