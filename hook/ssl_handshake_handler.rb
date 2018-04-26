def update_cert(redis, acme, domain, ttl)
  if take_a_lock(redis, domain)
    acme.auto_cert_deploy
    delete_unnecessary_keys(redis, acme, domain)
    set_expiry_limit(redis, domain, ttl)
  else
    sleep 1
  end
end

def take_a_lock(redis, domain)
  redis.hsetnx "#{domain}_lock", 'lock', 'lock'
  redis.expire "#{domain}_lock", 30
end

def delete_unnecessary_keys(redis, acme, domain)
  acme.clear
  redis.del "#{domain}_private_key"
  redis.del "#{domain}_lock"
end

def set_expiry_limit(redis, domain, ttl)
  %W[
    #{domain}.key
    #{domain}.crt
  ].each { |key| redis.expire key, ttl }
end

def not_allowed_domain?(redis, domain)
  true unless redis.exists?(domain)
end

def initialize_acme_client(endpoint, domain, redis)
  Nginx::SSL::ACME::Client.new(
    endpoint,
    domain,
    redis,
    false,
    []
  )
end

def certificate_keys_are_not_exists?(redis, domain)
  true if redis["#{domain}.crt"].nil? || redis["#{domain}.key"].nil?
end

u = Userdata.new
ssl = Nginx::SSL.new
domain = ssl.servername
Nginx.log Nginx::LOG_ERR, "#{domain}"
redis = Redis.new u.redis_host, u.redis_port
raise 'Domain not allowed.' if not_allowed_domain?(redis, domain)
acme = initialize_acme_client(u.endpoint, domain, redis)

while certificate_keys_are_not_exists?(redis, domain)
  update_cert(redis, acme, domain, u.ttl)
end

ssl.certificate_data = redis["#{domain}.crt"]
ssl.certificate_key_data = redis["#{domain}.key"]
