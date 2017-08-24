def token_value(redis, domain)
  token_value = redis["#{domain}_token_value"]
  token_value
rescue
  'can_not_get_token_value'
end

redis = Redis.new 'redis', 6379
domain = Nginx::Request.new.hostname
Nginx.rputs token_value(redis, domain)
