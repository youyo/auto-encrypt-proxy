ssl = Nginx::SSL.new
domain = ssl.servername
redis = Redis.new 'redis', 6379
endpoint = 'https://acme-v01.api.letsencrypt.org/'
endpoint = 'https://acme-staging.api.letsencrypt.org/' if ENV['STAGE'] =~ /^dev/
ttl = 5184000
allow_domain = []

acme = Nginx::SSL::ACME::Client.new(
  endpoint,
  domain,
  redis,
  false,
  allow_domain
)

raise 'not allowed servername' unless redis.exists?(domain)

if redis["#{domain}.crt"].nil? || redis["#{domain}.key"].nil?
  acme.auto_cert_deploy
  %W[
    #{domain}_authorization_uri
    #{domain}_token_value
    #{domain}_private_key
    #{domain}.key
    #{domain}.crt
  ].each { |key| redis.expire key, ttl }
end

ssl.certificate_data = redis["#{domain}.crt"]
ssl.certificate_key_data = redis["#{domain}.key"]
