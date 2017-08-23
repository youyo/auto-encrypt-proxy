userdata = Userdata.new
userdata.ttl = 5184000
userdata.endpoint = 'https://acme-v01.api.letsencrypt.org/'
if ENV['STAGE'] =~ /^dev/
  userdata.endpoint = 'https://acme-staging.api.letsencrypt.org/'
end
