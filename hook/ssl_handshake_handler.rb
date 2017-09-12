ssl = Nginx::SSL.new
domain = ssl.servername
redis = Redis.new ENV['REDIS_HOST'], ENV['REDIS_PORT'].to_i
endpoint = 'https://acme-v01.api.letsencrypt.org/'
endpoint = 'https://acme-staging.api.letsencrypt.org/' if ENV['STAGE'] =~ /^dev/
ttl = ENV['TTL']
allow_domain = []

raise 'Domain not allowed.' unless redis.exists?(domain)

acme = Nginx::SSL::ACME::Client.new(
  endpoint,
  domain,
  redis,
  false,
  allow_domain
)

if redis["#{domain}.crt"].nil? || redis["#{domain}.key"].nil?
  acme.auto_cert_deploy
  %W[
    #{domain}_authorization_uri
    #{domain}_token_value
    #{domain}.key
    #{domain}.crt
  ].each { |key| redis.expire key, ttl }
end

ssl.certificate_data = redis["#{domain}.crt"]
ssl.certificate_key_data = redis["#{domain}.key"]
