# ngx-mruby-auto-encrypt-proxy

## Required

- redis

## Run

### Provision

Use public docker image, and use redis container.

```
git pull youyo/ngx-mruby-auto-encrypt-proxy:latest
docker container run -d --name redis redis:latest
docker container run -d --link "redis:redis" -p 80:80 -p 443:443 youyo/ngx-mruby-auto-encrypt-proxy:latest
```

Use docker-compose.

```
git clone https://github.com/youyo/ngx-mruby-auto-encrypt-proxy.git
docker-compose up -d
```

### Initialize

Set data to redis.  
Set the key with the domain to which access is permitted as the key.

```
docker container exec -it redis redis-cli set example.com 1
```

### Access

```
curl -v https://example.com/
```
