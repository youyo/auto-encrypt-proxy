def token_value
  redis = Redis.new 'redis', 6379
  domain = Nginx::Request.new.hostname
  token_value = redis["#{domain}_token_value"]
  token_value
end

Nginx.rputs token_value
