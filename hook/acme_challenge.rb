redis = Redis.new 'redis', 6379
domain = Nginx::Request.new.hostname
token_value = redis["#{domain}_token_value"]
Nginx.rputs token_value
