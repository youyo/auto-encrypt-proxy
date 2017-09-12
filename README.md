# auto-encrypt-proxy

## Required

- redis docker container

## Run

### Provision

Use public docker image, and use redis container.

```
docker container run -d --name redis redis:latest
docker container run -d --link "redis:redis" -e REDIS_HOST=redis -p 80:80 -p 443:443 youyo/auto-encrypt-proxy:latest
```

Use docker-compose.

```
git clone https://github.com/youyo/auto-encrypt-proxy.git
cd auto-encrypt-proxy/
docker-compose up -d
```

### Initialize

Set data to redis.  
Set the key with the domain to which access is permitted as the key.

```
docker container exec -it redis redis-cli lpush example.com 192.168.0.10 192.168.0.11 ...
```

### Access

```
https://example.com/
```
