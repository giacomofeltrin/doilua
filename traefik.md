mkdir traefik
cd traefik
docker network create traefik-public

vim docker-compose.yml

```
version: "3.9"

services:
  reverse-proxy:
    image: traefik:v3.2
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entryPoints.web.address=:80"
      - "--entryPoints.websecure.address=:443"
      - "--certificatesresolvers.myresolver.acme.httpchallenge=true"
      - "--certificatesresolvers.myresolver.acme.httpchallenge.entrypoint=web"
      - "--certificatesresolvers.myresolver.acme.email=vitrua.studio@gmail.com"
      - "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
    ports:
      - "80:80"     # HTTP
      - "443:443"   # HTTPS
      - "8080:8080" # Traefik dashboard
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - "./letsencrypt:/letsencrypt" # Volume for storing certificates

  gotosocial:
    image: superseriousbusiness/gotosocial:latest
    container_name: gotosocial
    user: "1000:1000"
    environment:
      GTS_HOST: x.vitrua.top
      GTS_DB_TYPE: sqlite
      GTS_DB_ADDRESS: /gotosocial/storage/sqlite.db
      GTS_LETSENCRYPT_ENABLED: "true"
      GTS_LETSENCRYPT_EMAIL_ADDRESS: "vitrua.studio@gmail.com"
      GTS_WAZERO_COMPILATION_CACHE: /gotosocial/.cache
      TZ: Europe/Rome
    volumes:
      - ~/gotosocial/data:/gotosocial/storage
      - ~/gotosocial/.cache:/gotosocial/.cache
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.gotosocial.rule=Host(`x.vitrua.top`)"
      - "traefik.http.routers.gotosocial.entrypoints=websecure"
      - "traefik.http.routers.gotosocial.tls.certresolver=myresolver"
    networks:
      - default
    restart: always

networks:
  default:
    name: traefik-public
    external: true

```

docker-compose up -d reverse-proxy
