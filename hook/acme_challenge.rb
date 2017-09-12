def token_value(redis, domain)
  token_value = redis["#{domain}_token_value"]
  token_value
rescue
  'can_not_get_token_value'
end

redis = Redis.new ENV['REDIS_HOST'], ENV['REDIS_PORT'].to_i
domain = Nginx::Request.new.hostname
Nginx.rputs token_value(redis, domain)
